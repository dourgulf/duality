﻿// By default, we assume GLSL version 1.2, which corresponds to OpenGL 2.1.
// You can override this on a per-shader basis by adding your own version directive.
#version 120

// Transforms the specified vertex from world space into clip space.
// (Clip space is the expected vertex shader output)
vec4 TransformWorldToClip(vec4 worldPos)
{
	return gl_ModelViewProjectionMatrix * worldPos;
}

// Transforms the specified vertex from world space into view space.
vec4 TransformWorldToView(vec4 worldPos)
{
	return gl_ModelViewMatrix * worldPos;
}

// Transforms the specified vertex from view space into clip space.
// (Clip space is the expected vertex shader output)
vec4 TransformViewToClip(vec4 viewPos)
{
	return gl_ProjectionMatrix * viewPos;
}

// Performs the default vertex shader coordinate transformation that
// Duality uses. This accounts for both parallax and flat rendering,
// as well as separate depth offsets.
vec4 TransformVertexDefault(vec3 worldPos, float depthOffset)
{
	// Transform world position into view space
	vec4 viewPos = TransformWorldToView(vec4(worldPos, 1.0));

	// Transform view space position into clip space, with and without view space Z offset
	vec4 clipPos = TransformViewToClip(viewPos);
	vec4 offsetClipPos = TransformViewToClip(viewPos + vec4(0, 0, depthOffset, 0));

	// Return projection result, but override depth value, so it will
	// have the intended offset after perspective divide.
	return vec4(
		clipPos.xy, 
		offsetClipPos.z * clipPos.w / offsetClipPos.w, 
		clipPos.w);
}