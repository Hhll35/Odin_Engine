package main

import "core:fmt"
// C interoperation compatibility
import "core:c"

// Here we import OpenGL and rename it to gl for short
import gl "vendor:OpenGL"
// We use GLFW for cross platform window creation and input handling
import "vendor:glfw"


PROGRAMNAME :: "Program"

// GL_VERSION define the version of OpenGL to use. Here we use 4.6 which is the newest version
GL_MAJOR_VERSION : c.int : 4
// Constant with type inference
GL_MINOR_VERSION :: 6

running : b32 = true

main :: proc() {
	// Set Window Hints
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR,GL_MAJOR_VERSION) 
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR,GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)
	
	// Initialize glfw
	if(!glfw.Init()){
		// Print Line
		fmt.println("Failed to initialize GLFW")
		// Return early
		return
	}
	defer glfw.Terminate()

	// Create the window
	// Return WindowHandle rawPtr
	window := glfw.CreateWindow(512, 512, PROGRAMNAME, nil, nil)

	defer glfw.DestroyWindow(window)

	// If the window pointer is invalid
	if window == nil {
		fmt.println("Unable to create window")
		return
	}
	
	glfw.MakeContextCurrent(window)
	
	glfw.SwapInterval(1)

	// This function sets the key callback of the specified window, which is called when a key is pressed, repeated or released.
	glfw.SetKeyCallback(window, key_callback)

	// This function sets the framebuffer resize callback of the specified window, which is called when the framebuffer of the specified window is resized.
	glfw.SetFramebufferSizeCallback(window, size_callback)

	// Set OpenGL Context bindings using the helper function

	gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address) 
	
	init()
	
	for (!glfw.WindowShouldClose(window) && running) {
		// Process waiting events in queue
		glfw.PollEvents()
		
		update()
		draw()

		// This function swaps the front and back buffers of the specified window.
		glfw.SwapBuffers((window))
	}

	exit()
	
}


init :: proc(){
	// Own initialization code there
}

update :: proc(){
	// Own update code here
}

draw :: proc(){
	// Set the opengl clear color
	// 0-1 rgba values
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	// Clear the screen with the set clearcolor
	gl.Clear(gl.COLOR_BUFFER_BIT)

	// Own drawing code here
}

exit :: proc(){
	// Own termination code here
}

// Called when glfw keystate changes
key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	// Exit program on escape pressed
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

// Called when glfw window changes size
size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}