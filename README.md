Geometry, Textures & Shaders Tutorial for CAN
===================================

Fully commented code examples for the Geometry, Textures & Shaders tutorial I've written for [CreativeApplications.net](http://www.creativeapplications.net/).
You can find and read the complete tutorial [here](http://www.creativeapplications.net/processing/geometry-textures-shaders-processing-tutorial/).
Code tested & working under Windows (7 x64 and XP SP3 x32) for both NVIDIA (GTX 570M) and Radeon (HD 4800).
Since Processing 2.0 was still in development at the time of writing, the examples were initially made available for Processing 1.5.1 (with the GLGraphics library).
As a service during 2.0 development and since Processing 2.0 Final has been released now, the examples are also made available for Processing 2.0b8/2.0b9/2.0 Final.

* Code examples for [Processing 1.5.1.](http://processing.org/download/) and in most cases [GLGraphics 1.0.0](http://glgraphics.sourceforge.net/) are in [this repo](https://github.com/AmnonOwed/P5_CanTut_GeometryTexturesShaders).
* Code examples for [Processing 2.0b8/2.0b9/2.0Final](http://processing.org/download/) are in [this repo](https://github.com/AmnonOwed/P5_CanTut_GeometryTexturesShaders2B8).

Note: To save some space, many of these sketches share one central **_Images** folder!

####Custom2DGeometry
Creating a custom 2D shape with interpolated colors using beginShape-vertex-endShape.

####Custom3DGeometry
Creating a custom 3D shape with interpolated colors using beginShape-vertex-endShape.

####DynamicTextures2D
Creating textured QUADS with dynamically generated texture coordinates.

####FixedMovingTextures2D
Creating MOVING custom 2D shapes with either FIXED or MOVING textures. See the difference.

####GLSL_Heightmap
Creating a heightmap through GLSL with separate color and displacement maps that can be changed in realtime.

####GLSL_HeightmapNoise
Creating a GLSL heightmap running on shader-based procedural noise instead of a displacement map texture.

####GLSL_SphereDisplacement
Displacing a sphere outwards through GLSL with separate color and displacement maps that can be changed in realtime.

####GLSL_SphereDisplacementNoise
Displacing a sphere outwards through GLSL with shader-based procedural noise instead of a displacement map texture.

####GLSL_TextureMix
Creating a smooth mix between multiple textures in the fragment shader.

####MultiTexturedSphereGLSL
Applying a GLSL shader with multiple input textures to the TexturedSphere example.

####Texture2DAnimation
Creating an animation by using texture coordinates to read from a spritesheet.

####TexturedSphere
Creating a correctly textured sphere by subdividing an icosahedron.

####TexturedSphereGLSL
Adding a basic GLSL shader for dynamic lighting to the TexturedSphere example.
