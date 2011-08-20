require 'sinatra'
require 'builder'
require 'haml'
require 'json'

module ThyDungeonman
  class Application < Sinatra::Base

    set :haml, {:format => :html5}

    enable :sessions
    enable :reload_templates

    get '/' do
      haml :index
    end

    get '/commands.grxml' do
      content_type 'application/grammar-xml', :charset => 'utf-8'
      builder :grammar
    end

    post '/start.json' do
      initialize_session!
      erb :start, :layout => :tropo
    end

    post '/hangup.json' do
      @score = score
      erb :hangup, :layout => :tropo
    end

    post '/rooms/main.json' do
      @room = "main"
      @description = "Ye find yeself in yon dungeon. "
      @description << "Ye see a SCROLL. " unless has?(:scroll)
      @description << (has?(:scroll) ? "Back yonder there is a FLASK. " :
                                       "Behind ye scroll is a FLASK. "    ) unless has?(:flask)
      @description << "Obvious exits are NORTH, SOUTH, and DENNIS. "

      erb :room, :layout => :tropo
    end

    post '/rooms/north.json' do
      @room = "north"
      @description = "You go NORTH through yon corrider. " + "You arrive at parapets. "
      @description << "Ye see a rope. " unless has?(:rope)
      @description << "Obvious exits are SOUTH."

      erb :room, :layout => :tropo
    end

    post '/rooms/south.json' do
      @room = "south"
      if not has?(:trinket)
        @description = "You head south to an enbankment. Or maybe a chasm. You can't decide which. "
        @description << "Anyway, ye spies a TRINKET. "
      else
        @description = "Ye stand high above a canyon-like depression. "
      end

      @description << "Obvious exits are NORTH. "

      erb :room, :layout => :tropo
    end

    post '/rooms/dennis.json' do
      @room = "dennis"
      @description = "Ye arrive at Dennis. He wears a sporty frock coat and a long jimberjam. He paces about nervously. "
      @description << "Obvious exits are NOT DENNIS. "

      erb :room, :layout => :tropo
    end

    post '/rooms/:room/command.json' do
      @room = params[:room]
      @predicate, @object = extract_predicate_and_object!(request)

      @description =  case @room
                        when 'main'
                          case @predicate
                            when 'look'
                              case @object
                                when 'scroll'
                                  if not has?(:scroll)
                                    "Parchment, definitely parchment. I'd recognize it anywhere."
                                  else
                                    "Ye seeth nothing wheretofore it went ZAP."
                                  end
                                when 'flask'
                                  "Looks like you could quaff some serious mead out of that thing."
                              end

                            when 'get', 'take'
                              case @object
                                when 'scroll'
                                  if not has?(:scroll)
                                    get!(:scroll) and score!(1)
                                    "Ye takes the scroll and reads of it. It doth say: BEWARE, READER OF THE SCROLL, DANGER AWAITS TO THE- The SCROLL disappears in thy hands with ye olde ZAP!"
                                  else
                                    "Ye doth suffer from memory loss. YE SCROLL is no more. Honestly."
                                  end
                                when 'flask'
                                  if not flask!
                                    score!(1)
                                    "Ye cannot get the FLASK. It is firmly bolted to a wall which is bolted to the rest of the dungeon which is probably bolted to a castle. Never you mind."
                                  else
                                    get!(:flask) and score!(-1000) and @hangup = true
                                    "Okay, okay. You unbolt yon FLASK and hold it aloft. A great shaking begins. The dungeon ceiling collapses down on you, crushing you in twain. Apparently, this was a load-bearing FLASK."
                                  end
                              end
                          end

                        when 'north'
                          case @predicate
                            when 'look'
                              case @object
                                when 'parapets'
                                  "Well, they're parapets. This much we know for sure."
                                when 'rope'
                                  "It looks okay. You've seen better."
                              end

                            when 'get', 'take'
                              case @object
                                when 'rope'
                                  score!(-1) and @hangup = true
                                  "You attempt to take ye ROPE but alas it is enchanted! It glows a mustard red and smells like a public privy. The ROPE wraps round your neck and hangs you from parapets. With your last breath, you wonder what parapets are."
                              end
                          end

                        when 'south'
                          case @predicate
                            when 'look'
                              case @object
                                when 'trinket'
                                  if not has?(:trinket)
                                    "Quit looking! Just get it already."
                                  else
                                    "Just a bulge in thou pouchel at thist point."
                                  end
                                when 'rope'
                                  "It looks okay. You've seen better."
                              end

                            when 'get', 'take'
                              case @object
                                when 'trinket'
                                  if not has?(:trinket)
                                    get!(:trinket) and score!(1)
                                    "Ye getsts yon TRINKET and discover it to be a bauble. You rejoice at your good fortune. You shove the TRINKET in your pouchel. It kinda hurts."
                                  else
                                    score!(-1)
                                    "Sigh. The trinket is in thou pouchel. Recallest thou?"
                                  end
                              end
                          end

                        when 'dennis'
                          case @predicate
                            when 'talk'
                              "You engage Dennis in leisurely discussion. Ye learns that his jimberjam was purchased on sale at a discount market and that he enjoys pacing about nervously. You become bored and begin thinking about parapets."
                            when 'look'
                              case @object
                                when 'dennis'
                                  "That jimberjam really makes the outfit."
                                when 'jimberjam'
                                  "Man, that art a nice jimberjam."
                              end

                            when 'give'
                              case @object
                                when 'trinket'
                                  if use!(:trinket)
                                    @hangup = true
                                    "A novel idea! You givst the TRINKET to Dennis and he happily agrees to tell you what parapets are. With this new knowledge, ye escapes from yon dungeon in order to search for new dungeons and to remain... THY DUNGEONMAN!! You hath won! Congraturation!!"
                                  else
                                    "Thou don'tst have a trinket to give. Go back to your tiny life."
                                  end
                              end
                          end
                      end

      @description ||=  case @predicate
                          when 'die'
                            @hangup = true
                            "That wasn't very smart."
                          when 'dance'
                            "Thou shaketh it a little, and it feeleth all right."
                          when 'smell'
                            "You smell a Wumpus."
                        end

      @next = '/hangup' if @hangup
      @next ||= case @object
                when 'north'
                  case @room
                  when 'main'   then '/rooms/north'
                  when 'south'  then '/rooms/main'
                  end
                when 'south'
                  case @room
                    when 'main'   then '/rooms/south'
                    when 'north'  then '/rooms/main'
                  end
                when 'dennis'
                  case @room
                    when 'main'   then '/rooms/dennis'
                    when 'dennis' then '/rooms/main'
                  end
                else
                  '/rooms/' + @room
                end

      erb :command, :layout => :tropo
    end

  protected

    def extract_predicate_and_object!(request)
      input = JSON.parse(request.env["rack.input"].read) rescue nil
      tokens = input["result"]["actions"]["interpretation"].split(/\s+/) rescue []
      return [tokens.first, tokens.last]
    end

    def initialize_session!
      session[:score] = 0
      session[:inventory] = {}
      session[:flask] = 0
    end

    def score
      session[:score]
    end

    def score!(points)
      session[:score] += points
    end

    def has?(item)
      session[:inventory][item.to_sym]
    end

    def get!(item)
      session[:inventory][item.to_sym] = true
    end

    def use!(item)
      if session[:inventory][item.to_sym]
        session[:inventory][item.to_sym] = false
        return true
      else
        return false
      end
    end

    def flask!
      session[:flask] += 1
      return session[:flask] >= 3
    end
  end
end