zone :castle do
  
  room :kings_chamber do |r|
    r.portal :s, "great_hall"
    
    r.title "King's Chamber"
    r.description <<-DESC
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
      velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
      occaecat cupidatat non proident, sunt in culpa qui officia deserunt
      mollit anim id est laborum.
    DESC
  end
  
  room :great_hall do |r|
    r.portals(:n => "kings_chamber", :s => "courtyard")
    
    r.title "The Great Hall"
    r.description <<-DESC
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex
      ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
      velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
      cupidatat non proident, sunt in culpa qui officia deserunt mollit anim
      id est laborum.
    DESC
    
    r[:door_closed] = true
    
    r.rule "n" do |c,m|
      if c.room[:door_closed]
        c.error "But the door is closed!"
        c.handled!
      end
    end
    
    r.rule "open door" do |c,m|
      c.success "You open the door"
      c.room[:door_closed] = false
      c.handled!
    end
    
    r.rule "close door" do |c,m|
      c.success "You close the door"
      c.room[:door_closed] = true
      c.handled!
    end
    
  end
  
  room :courtyard do |r|
    r.portal :n, "great_hall"
    
    r.title "Courtyard"
    r.description <<-DESC
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
      velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
      occaecat cupidatat non proident, sunt in culpa qui officia deserunt
      mollit anim id est laborum.
    DESC
  end
end
