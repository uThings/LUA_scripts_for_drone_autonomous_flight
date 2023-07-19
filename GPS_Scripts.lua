
local num_guided_mode = 4
local num_brake_mode = 17
local num_stabilize_mode = 0
local takeoff_altitude = 10
local num_rtl = 6
local phase = 0
local angle_increase = 4
local omega = 0
local alpha = 0
local theta = 0
local controlch = 14
local figurech = 13
local sq_dimension = 10
function update()
  local start_pos = ahrs:get_position()
  local home = ahrs:get_home()

  if not arming:is_armed() then
    phase = 0
    gcs:send_text(0,"The drone is not armed")
  else
    controlchannel = rc:get_pwm(controlch) --Manual/Auto/Hover
    if controlchannel and controlchannel < 1300 then 
        vehicle:set_mode(num_stabilize_mode)
    elseif controlchannel > 1300 and controlchannel <1800 then
      channel = rc:get_pwm(figurech)
      if channel and channel > 1100 and channel < 1300 then
        -- Square button
        if (phase == 0) then
          vehicle:set_mode(num_guided_mode)
          if (vehicle:start_takeoff(takeoff_altitude)) then
            phase = phase + 1
          end
    
    -- Phase 1: Wait to reach takeoff altitude
        elseif (phase == 1) then
          home = ahrs:get_home()
          current_loc = ahrs:get_position()
          if home and current_loc then
            home_distance_vector = home:get_distance_NED(current_loc)
            gcs:send_text(0,"Alt: " .. tostring(math.floor(-home_distance_vector:z())))
              if (math.abs(takeoff_altitude + home_distance_vector:z())< 1) then
                phase = phase + 1
                gcs:send_text(0,"Coords: " .. tostring(math.floor(home_distance_vector:x())) .. tostring(",") .. tostring(math.floor(home_distance_vector:y()))..tostring(",") .. tostring(math.floor(-home_distance_vector:z())))
              end
          end
    -- Phase 2: Calculate first square vertice coordinates and start moving to it
        elseif (phase == 2) then
          gcs:send_text(0, "Start square") 
          local current_position = ahrs:get_position() 
          first_wp = Location()
          current_position:offset(sq_dimension,0)
          first_wp:lat(current_position:lat())
          first_wp:lng(current_position:lng())
          first_wp:alt(current_position:alt())
          if (vehicle:set_target_location(first_wp)) then
            phase = phase + 1
          end
    -- Phase 3: Wait for drone to reach first vertice coordinates
        elseif (phase == 3) then
          new_position = ahrs:get_position()
          if new_position then
            from_wp_to_current = new_position:get_distance_NED(first_wp)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
            if (math.abs(from_wp_to_current:x())< 1) then
              phase = phase +1
            end
          end
     -- Phase 4: Calculate second square vertice coordinates and start moving to that point  
    
        elseif (phase == 4) then
          local fwp_position = ahrs:get_position()
          second_wp = Location()
          fwp_position:offset(0,-sq_dimension)
          second_wp:lat(fwp_position:lat())
          second_wp:lng(fwp_position:lng())
          second_wp:alt(fwp_position:alt())
          if (vehicle:set_target_location(second_wp)) then
            phase = phase +1
          end
    -- Phase 5: Wait for drone to reach second vertice coordinates
        elseif (phase == 5) then
          new_position = ahrs:get_position()
          if new_position then
            from_wp_to_current = new_position:get_distance_NED(second_wp)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
            if (math.abs(from_wp_to_current:y())< 1) then
              phase = phase +1
            end
          end    
    -- Phase 6: Calculate third square vertice coordinates and start moving to that point
        elseif (phase == 6) then
          local swp_position = ahrs:get_position()
          third_wp = Location()
          swp_position:offset(-sq_dimension,0)
          third_wp:lat(swp_position:lat())
          third_wp:lng(swp_position:lng())
          third_wp:alt(swp_position:alt())
          if (vehicle:set_target_location(third_wp)) then
            phase = phase +1
          end
    -- Phase 7: Wait for drone to reach third vertice coordinates   
        elseif (phase == 7) then
          new_position = ahrs:get_position()
          if new_position then
            from_wp_to_current = new_position:get_distance_NED(third_wp)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
            if (math.abs(from_wp_to_current:x())< 1) then
              phase = phase +1
            end
          end
    -- Phase 8: Calculate fourth square vertice coordinates and start moving to that point
        elseif (phase == 8) then
          local twp_position = ahrs:get_position()
          fourth_wp = Location()
          twp_position:offset(0,sq_dimension)
          fourth_wp:lat(twp_position:lat())
          fourth_wp:lng(twp_position:lng())
          fourth_wp:alt(twp_position:alt())
          if (vehicle:set_target_location(fourth_wp)) then
            phase = phase +1
          end
    -- Phase 9: Wait for drone to reach fourth vertice coordinates  
        elseif (phase == 9) then
          new_position = ahrs:get_position()
          if new_position then
            from_wp_to_current = new_position:get_distance_NED(fourth_wp)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
            if (math.abs(from_wp_to_current:y())< 1) then
              phase = phase +1
            end
          end    
               
    -- Phase 10: Return to launch
        elseif (phase == 10) then
          gcs:send_text(0, "Square completed, returning to launch")
          vehicle:set_mode(num_rtl)     
        end

      elseif channel > 1300 and channel < 1500 then
        -- Circle button
        if (phase == 0) then
          theta = 0
          vehicle:set_mode(num_guided_mode)
          if (vehicle:start_takeoff(takeoff_altitude)) then
            phase = phase + 1
          end
    
    -- Phase 1: Wait to reach takeoff altitude
        elseif (phase == 1) then
          home = ahrs:get_home()
          current_loc = ahrs:get_position()
          if home and current_loc then
            home_distance_vector = home:get_distance_NED(current_loc)
            gcs:send_text(0,"Alt: " .. tostring(math.floor(-home_distance_vector:z())))
              if (math.abs(takeoff_altitude + home_distance_vector:z())< 1) then
                phase = phase + 1
                gcs:send_text(0,"Coords: " .. tostring(math.floor(home_distance_vector:x())) .. tostring(",") .. tostring(math.floor(home_distance_vector:y()))..tostring(",") .. tostring(math.floor(-home_distance_vector:z())))
                gcs:send_text(0, "Start circle") 
              end
          end
    -- Phase 2: Make circle
        elseif (phase == 2) then
          local current_position = ahrs:get_position() 
          circleWP = Location()
          current_position:offset(math.sin(math.rad(theta)),math.cos(math.rad(theta))) --Circumference points location degree by degree
          circleWP:lat(current_position:lat())
          circleWP:lng(current_position:lng())
          circleWP:alt(current_position:alt())
          theta= theta+angle_increase
          vehicle:set_target_location(circleWP)
          if (theta >= 360) then
            phase = phase +1
          end 
          if (vehicle:set_target_location(circleWP)) then
            from_wp_to_current = current_loc:get_distance_NED(circleWP)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
          end
    
    -- Fase 3: Return to launch
        elseif (phase == 3) then
          gcs:send_text(0, "Circle completed, returning to launch")
          vehicle:set_mode(num_rtl)
        end

      elseif channel > 1500 and channel < 1700 then
        -- Eight button
        if (phase == 0) then
          alpha = 0
          omega = 0
          vehicle:set_mode(num_guided_mode)
          if (vehicle:start_takeoff(takeoff_altitude)) then
            phase = phase + 1
          end
    
    -- Phase 1: Wait to reach takeoff altitude
        elseif (phase == 1) then
          home = ahrs:get_home()
          current_loc = ahrs:get_position()
          if home and current_loc then
            home_distance_vector = home:get_distance_NED(current_loc)
            gcs:send_text(0,"Alt: " .. tostring(math.floor(-home_distance_vector:z())))
              if (math.abs(takeoff_altitude + home_distance_vector:z())< 1) then
                phase = phase + 1
                gcs:send_text(0,"Coords: " .. tostring(math.floor(home_distance_vector:x())) .. tostring(",") .. tostring(math.floor(home_distance_vector:y()))..tostring(",") .. tostring(math.floor(-home_distance_vector:z())))
                gcs:send_text(0, "Start Eight") 
              end
          end
    -- Phase 2: Make first half eight 
        elseif (phase == 2) then
          
          local current_position = ahrs:get_position() 
          local circleWP = Location()
          current_position:offset(math.sin(math.rad(omega)),math.cos(math.rad(omega))) --Circumference points location degree by degree
          circleWP:lat(current_position:lat())
          circleWP:lng(current_position:lng())
          circleWP:alt(current_position:alt())
          omega= omega+angle_increase
          vehicle:set_target_location(circleWP)
          if (omega >= 360) then
            phase = phase +1
          end 
          if (vehicle:set_target_location(circleWP)) then
            from_wp_to_current = current_loc:get_distance_NED(circleWP)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
          end
    
    -- Phase 3: Complete eight 
        elseif (phase == 3) then
          local current_position = ahrs:get_position() 
          local circleWP = Location()
          current_position:offset(math.sin(math.rad(alpha)),math.cos(math.rad(alpha))) --Circumference points location degree by degree
          circleWP:lat(current_position:lat())
          circleWP:lng(current_position:lng())
          circleWP:alt(current_position:alt())
          alpha = alpha-angle_increase
          vehicle:set_target_location(circleWP)
          if (alpha <= -360) then
            phase = phase +1
          end 
          if (vehicle:set_target_location(circleWP)) then
            from_wp_to_current = current_loc:get_distance_NED(circleWP)
            gcs:send_text(0,"Coords: " .. tostring(math.floor(from_wp_to_current:x())) .. tostring(",") .. tostring(math.floor(from_wp_to_current:y()))..tostring(",") .. tostring(math.floor(-from_wp_to_current:z())))
          end
    
    -- Fase 4: Return to launch
        elseif (phase == 4) then
          gcs:send_text(0, "Eight completed, returning to launch")
          vehicle:set_mode(num_rtl)
          omega = 0
          alpha = 0
        end
      end
    elseif controlchannel > 1800 then
      -- Stop and hover with GPS for emergency use
      vehicle:set_mode(num_brake_mode)
    end
  end

  return update, 200
end

return update()


