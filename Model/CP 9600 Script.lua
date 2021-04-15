--adjust these to something sensible for your loco
IDLERPM = 200
FULLRPM = 850
MAXAMPS = 2000

--this is the smoke generation rate, higher means less smoke, towards 0 means maximum smoke
RATE = 0.04
--this controls smoke discoloration at low power settings, 1 means dark black, higher is lighter gray
COL = 4
--this controls smoke generation at high RPMs, 0 means none, 1 means a lot
RPMCF = 0.3
--this controls smoke generation at high load (amperage), meaning as above
AMPCF = 0.7
--this controls the blueness of the smoke, 1.2 is bluish smoke, 0.8 is brownish smoke
BLNSS = 1.0

RPM_ID = 1709
RPMD_ID = 1710
AMPS_ID = 1711


function Initialise ()

gPrevRPM = 0
gPrevRPMDelta = 0
gPrevAmps = 0
   
--uncomment these to randomize smoke generation for each locomotive
RPMCF = math.random()
AMPCF = math.random()
BLNSS = 0.8 + (math.random() * 0.4)
COL = math.random() * 10
RATE = math.random() / 10

	Call( "BeginUpdate" )
	Call( "Exhaust:SetEmitterActive", 1 )

end


function OnControlValueChange ( name, index, value )

	if Call( "*:ControlExists", name, index ) then
		Call( "*:SetControlValue", name, index, value );
	end

end


function Update ( time )

	if Call("*:GetControlValue", "CabLight", 0) == 0 then
		Call("CabLight:Activate", 0)
	else
		Call("CabLight:Activate", 1)
	end

-- Get rpm values for this vehicle.
rpm = Call( "*:GetControlValue", "RPM", 0 )
rpm_change = Call( "*:GetControlValue", "RPMDelta", 0 )
amps = Call("*:GetControlValue", "Ammeter", 0)

--compute control values as ratio to max
gCurRPM = (rpm - IDLERPM) / (FULLRPM - IDLERPM);
gCurAmps = amps / MAXAMPS;

exhaustrate = RATE - RATE * ((( gCurRPM * RPMCF ) + (( gCurAmps ) * AMPCF )))
exh_col = (( MAXAMPS - amps ) / MAXAMPS ) * COL
	Call( "Exhaust:SetEmitterRate", exhaustrate )
	Call( "Exhaust:SetEmitterColour", exh_col, exh_col, exh_col*BLNSS )

end