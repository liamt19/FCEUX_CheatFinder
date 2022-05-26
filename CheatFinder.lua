require("auxlib");

math.randomseed(os.time())
math.random(); math.random(); math.random();


local loadMovie = true
local useTurbo = true
local code = ""
local movieName = "speedrun.fm2"


function RandomCode()
	charSet = "APZLGITYEOXUKSVN"
	local length = 6
	local output = ""
	for i = 1, length do
	    local rand = math.random(#charSet)
	    output = output .. string.sub(charSet, rand, rand)
	end
	
	return output
end

function DoNewCode()
	if string.len(code) == 6 then
		emu.delgamegenie(code)
	end;
		
	code = RandomCode()
	emu.addgamegenie(code)
	myoutput.value = code;
	emu.print(code)
	emu.softreset()

	if loadMovie then
		RestartMovie()
	end
end

function RestartMovie()
	loaded = movie.play(movieName, true)
	if useTurbo then
		emu.speedmode("turbo")
	else
		emu.speedmode("normal")
	end
	
end;

-- called by the onclose event (above)
function OnCloseIup()
	if (handles) then -- just in case the user was "smart" enough to clear this
		local i = 1;
		while (handles[i] ~= nil) do -- cycle through all handles, false handles are skipped, nil denotes the end
			if (handles[i] and handles[i].destroy) then -- check for the existence of what we need
				handles[i]:destroy(); -- close this dialog (:close() just hides it)
				handles[i] = nil;
			end;
			i = i + 1;
		end;
	end;
end;

function OnCloseMyStuff()
	if movie.active() then
		movie.close()
	end
	
	emu.delgamegenie(code)
end

function createGUI(n)
	local btn_restart = iup.button{title="Restart movie"};
	btn_restart.action = 
		function (self) 
			RestartMovie()
		end;
		
	local btn_newCode = iup.button{title="New code"};
	btn_newCode.action = 
		function (self) 
			DoNewCode()
		end;
	
	doMovie = iup.toggle{title="Load a movie", value="ON"};
	doMovie.action = 
		function(self, v) 
			if (v == 1) then
				loadMovie = false
				if movie.active() then
					movie.close()
				end;
			end;
		end;
	
	local btn_toggleTurbo = iup.button{title="Toggle turbo"};
	btn_toggleTurbo.action = 
		function(self) 
			if useTurbo then
				useTurbo = false
				emu.speedmode("normal")
			else
				useTurbo = true
				emu.speedmode("turbo")
			end;
		end;
	
	myoutput = iup.multiline{size="100x100",expand="YES",value=""}
	
	handles[n] = 
		iup.dialog{
		  iup.frame
		  {                   
				iup.vbox
				{
					iup.hbox {
						btn_restart,
						btn_newCode,
						gap=78,
						margin="5x5",
						alignment="ACENTER",
					},
					
					iup.hbox {
						doMovie,
						btn_toggleTurbo,
						gap=50,
						margin="5x5",
						alignment="ACENTER",
					},
					
					myoutput,
				}
			},
			title="CheatFinder"
		};

	handles[n]:showxy(430, 0)
end


dialogs = dialogs + 1;
createGUI(dialogs);

emu.registerexit(OnCloseMyStuff)

DoNewCode()

while (true) do
	FCEU.frameadvance();
end;
