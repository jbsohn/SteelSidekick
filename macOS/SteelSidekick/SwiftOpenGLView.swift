//
//  SwiftOpenGLView.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/17/17.
//  Copyright © 2017 John Sohn. All rights reserved.
//

import Cocoa

class SwiftOpenGLView: NSOpenGLView {
    required init?(coder: NSCoder) {
        //  Allow the super class to initialize it's properties (phase 1 initialization)
        super.init(coder: coder)
        
        //  Some OpenGL setup
        //  NSOpenGLPixelFormatAttribute is a typealias for UInt32 in Swift, but the individual
        //  attributes are Int's.  We have initialize them as Int32's to fit them into an array
        //  of NSOpenGLPixelFormatAttributes
        
        let attrs: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAAccelerated),            //  Use accelerated renderers
            UInt32(NSOpenGLPFAColorSize), UInt32(32),  //  Use 32-bit color
            UInt32(NSOpenGLPFAOpenGLProfile),          //  Use version's >= 3.2 core
            UInt32( NSOpenGLProfileVersion3_2Core),
            UInt32(0)                                  //  C API's expect to end with 0
        ]
        
        //  Create a pixel format using our attributes
        guard let pixelFormat = NSOpenGLPixelFormat(attributes: attrs) else {
            Swift.print("pixelFormat could not be constructed")
            return
        }
        self.pixelFormat = pixelFormat
        
        //  Create a context with our pixel format (we have no other context, so nil)
        guard let context = NSOpenGLContext(format: pixelFormat, share: nil) else {
            Swift.print("context could not be constructed")
            return
        }
        self.openGLContext = context

        
    }
    
    override func prepareOpenGL() {
        //  Allow the superclass to perform it's tasks
        super.prepareOpenGL()
        
        //  Setup OpenGL
        
        //  The buffer will clear each pixel to black upon starting the creation of a new frame
        //glClearColor(0.0, 0.0, 0.0, 1.0)
        
        /*  other setup here, e.g. gelable() calls */

        //  Run a test render
        drawView()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        
        //  Call our OpenGL rendering code.
        drawView()
    }
    
    private func drawView() {
        //  Clear out the context before rendering
        //  This uses the clear color we set earlier (0.0, 0.0, 0.0, 1.0 or black)
        //  We're only drawing with colors now, but if we were using a depth or stencil buffer
        //  we would also want to clear those here separated by "logical or" " | "
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        let sguitar = SGuitar.sharedInstance();
        let noteWidthHeight = sguitar?.cacluateNoteWidthHeight(Float(self.frame.size.width), height: Float(self.frame.size.height));
        sguitar?.initCanvas(Float(self.frame.size.width), height: Float(self.frame.size.height), noteWidthHeight: Float(noteWidthHeight!), borderWidth: 16.0, scale: 1.0, leftSafeArea: 0);
        sguitar?.draw();
        
        //  Tell OpenGL that you're done rendering and it's time to send the context to the screen
        glFlush()        
    }
}


