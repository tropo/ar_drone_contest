xml.instruct! :xml, :version => '1.0'
xml.grammar :xmlns => "http://www.w3.org/2001/06/grammar", :'xml:lang' => "en-US", :root => "ROOT" do
  xml.rule :id => "ROOT", :scope => :public do
    # Top-level Rule
    xml.item do
      # PREDICATE
      xml.item do
        xml.ruleref :uri => "#PREDICATE"
        xml.tag! :tag, "out.predicateSlot=rules.PREDICATE.predicateSubslot;"
      end
      
      # OBJECT
      xml.item do
        xml.ruleref :uri => "#OBJECT"
        xml.tag! :tag, "out.objectSlot=rules.OBJECT.objectSubslot;"
      end
      
      xml.tag! :tag, "out.v=out.predicateSlot + out.objectSlot;"
    end
  end
  
  # PREDICATEs
  xml.rule :id => "PREDICATE", :scope => :public do
    xml.tag! :'one-of' do
      xml.item do
        xml.tag! :'one-of' do
          ['help', 'helpeth', 'look'].each do |synonym|
            xml.item synonym
          end
        end
        xml.tag! :tag, "out.predicateSubslot=\"look\"; out.objectSlot=\"\";"
      end
      
      ['die', 'dance', 'go', 'talk', 'give'].each do |predicate|
        xml.item do
          xml.text! predicate
          xml.tag! :tag, "out.predicateSubslot=\"#{predicate} \";"
        end
      end
      
      xml.item do
        xml.tag! :'one-of' do
          ['get', 'take', 'get ye', 'take ye', 'get yon', 'take yon'].each do |synonym|
            xml.item synonym
          end
        end
        xml.tag! :tag, "out.predicateSubslot=\"get \";"
      end
      
      xml.item do
        xml.tag! :'one-of' do
          ['smell', 'sniff'].each do |synonym|
            xml.item synonym
          end
        end
        xml.tag! :tag, "out.predicateSubslot=\"smell \";  out.objectSlot=\"\";"
      end  
    end
  end
  
  # OBJECTs
  xml.rule :id => "OBJECT", :scope => :public do
    xml.tag! :'one-of' do
      ['north', 'south', 'dennis', 'not dennis', 'flask', 'scroll', 'trinket', 'parapets', 'rope', 'jimberjam'].each do |object|
        xml.item do
          xml.text! object
          xml.tag! :tag, "out.objectSubslot=\"#{object}\";"
        end
      end
    end
  end
end