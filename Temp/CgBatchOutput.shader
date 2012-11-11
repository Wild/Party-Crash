//
// LightningCloudShader.shader: Surface shader for clouds which uses a simple cloud lighting model.
//
// Author:
//   Andreas Suter (andy@edelweissinteractive.com)
//
// Copyright (C) 2012 Edelweiss Interactive (http://edelweissinteractive.com)
//

Shader "Cloud/Lightning Cloud" {

	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex ("Particle Texture", 2D) = "white" {}
	}
	
	SubShader {
		Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
	
			Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 2
//   opengl - ALU: 14 to 45
//   d3d9 - ALU: 14 to 45
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[11] = { { 0 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
DP4 R0.x, vertex.position, vertex.position;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, vertex.position;
MUL R0.xyz, R0, c[9].w;
MOV result.texcoord[1], vertex.color;
DP3 result.texcoord[2].z, R0, c[7];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[2].x, R0, c[5];
MOV result.texcoord[3].xyz, c[0].x;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c10, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v3
dcl_color0 v5
dp4 r0.x, v0, v0
rsq r0.x, r0.x
mul r0.xyz, r0.x, v0
mul r0.xyz, r0, c8.w
mov oT1, v5
dp3 oT2.z, r0, c6
dp3 oT2.y, r0, c5
dp3 oT2.x, r0, c4
mov oT3.xyz, c10.x
mad oT0.xy, v3, c9, c9.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = _glesColor.xyz;
  tmpvar_2.xyz = tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_4 = _glesColor.w;
  tmpvar_2.w = tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize (_glesVertex).xyz * unity_Scale.w));
  tmpvar_1 = tmpvar_6;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = vec3(0.0, 0.0, 0.0);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz * xlv_TEXCOORD1.xyz);
  tmpvar_1 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = (tmpvar_4.w * xlv_TEXCOORD1.w);
  tmpvar_2 = tmpvar_6;
  highp vec4 c_i0_i1;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_1 + _LightColor0.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD3));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = _glesColor.xyz;
  tmpvar_2.xyz = tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_4 = _glesColor.w;
  tmpvar_2.w = tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize (_glesVertex).xyz * unity_Scale.w));
  tmpvar_1 = tmpvar_6;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = vec3(0.0, 0.0, 0.0);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz * xlv_TEXCOORD1.xyz);
  tmpvar_1 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = (tmpvar_4.w * xlv_TEXCOORD1.w);
  tmpvar_2 = tmpvar_6;
  highp vec4 c_i0_i1;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_1 + _LightColor0.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD3));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [_MainTex_ST]
"agal_vs
c10 0.0 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeaaaaaaaa dp4 r0.x, a0, a0
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaaaaaaoeaaaaaaaa mul r0.xyz, r0.x, a0
adaaaaaaaaaaahacaaaaaakeacaaaaaaaiaaaappabaaaaaa mul r0.xyz, r0.xyzz, c8.w
aaaaaaaaabaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v1, a2
bcaaaaaaacaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r0.xyzz, c6
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
bcaaaaaaacaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r0.xyzz, c4
aaaaaaaaadaaahaeakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c10.x
adaaaaaaaaaaadacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.xy, a3, c9
abaaaaaaaaaaadaeaaaaaafeacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.xyyy, c9.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 45 ALU
PARAM c[19] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
DP4 R0.w, vertex.position, c[6];
DP4 R0.x, vertex.position, vertex.position;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, vertex.position;
MUL R3.xyz, R0, c[9].w;
ADD R1, -R0.w, c[11];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
MUL R2, R3.w, R1;
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].y;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.z, R1.z;
MAX R0, R0, c[0].x;
RCP R1.w, R1.w;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MOV R4.y, R3.w;
MOV R4.z, R3.x;
MAD result.texcoord[3].xyz, R0.w, c[17], R0;
MOV result.texcoord[2].xyz, R4;
MOV result.texcoord[1], vertex.color;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 45 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [_MainTex_ST]
"vs_2_0
; 45 ALU
def c18, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v3
dcl_color0 v5
dp4 r0.w, v0, c5
dp4 r0.x, v0, v0
rsq r0.x, r0.x
mul r0.xyz, r0.x, v0
mul r3.xyz, r0, c8.w
add r1, -r0.w, c10
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
mul r2, r3.w, r1
dp3 r3.x, r3, c6
dp4 r0.x, v0, c4
add r0, -r0.x, c9
mul r1, r1, r1
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c11
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c12
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c18.y
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.z, r1.z
max r0, r0, c18.x
rcp r1.w, r1.w
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mov r4.y, r3.w
mov r4.z, r3.x
mad oT3.xyz, r0.w, c16, r0
mov oT2.xyz, r4
mov oT1, v5
mad oT0.xy, v3, c17, c17.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = _glesColor.xyz;
  tmpvar_3.xyz = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = _glesColor.w;
  tmpvar_3.w = tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize (_glesVertex).xyz * unity_Scale.w));
  tmpvar_1 = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  highp vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  highp vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  highp vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_7.x) + (tmpvar_10 * tmpvar_7.y)) + (tmpvar_11 * tmpvar_7.z)) * inversesqrt (tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w));
  tmpvar_2 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz * xlv_TEXCOORD1.xyz);
  tmpvar_1 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = (tmpvar_4.w * xlv_TEXCOORD1.w);
  tmpvar_2 = tmpvar_6;
  highp vec4 c_i0_i1;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_1 + _LightColor0.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD3));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = _glesColor.xyz;
  tmpvar_3.xyz = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = _glesColor.w;
  tmpvar_3.w = tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize (_glesVertex).xyz * unity_Scale.w));
  tmpvar_1 = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  highp vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  highp vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  highp vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_7.x) + (tmpvar_10 * tmpvar_7.y)) + (tmpvar_11 * tmpvar_7.z)) * inversesqrt (tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w));
  tmpvar_2 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz * xlv_TEXCOORD1.xyz);
  tmpvar_1 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = (tmpvar_4.w * xlv_TEXCOORD1.w);
  tmpvar_2 = tmpvar_6;
  highp vec4 c_i0_i1;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_1 + _LightColor0.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD3));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [_MainTex_ST]
"agal_vs
c18 0.0 1.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.w, a0, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeaaaaaaaa dp4 r0.x, a0, a0
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaaaaaaoeaaaaaaaa mul r0.xyz, r0.x, a0
adaaaaaaadaaahacaaaaaakeacaaaaaaaiaaaappabaaaaaa mul r3.xyz, r0.xyzz, c8.w
bfaaaaaaabaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r0.w
abaaaaaaabaaapacabaaaappacaaaaaaakaaaaoeabaaaaaa add r1, r1.w, c10
bcaaaaaaadaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c5
bcaaaaaaaeaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c4
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaaajaaaaoeabaaaaaa add r0, r0.x, c9
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.y, a0, c6
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaaalaaaaoeabaaaaaa add r0, r0.y, c11
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaaamaaaaoeabaaaaaa mul r2, r1, c12
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaabcaaaaffabaaaaaa add r1, r2, c18.y
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabcaaaaaaabaaaaaa max r0, r0, c18.x
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
adaaaaaaafaaahacaaaaaaaaacaaaaaaanaaaaoeabaaaaaa mul r5.xyz, r0.x, c13
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaapaaaaoeabaaaaaa mul r0.xyz, r0.z, c15
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
adaaaaaaafaaahacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r5.xyz, r0.w, c16
abaaaaaaadaaahaeafaaaakeacaaaaaaaaaaaakeacaaaaaa add v3.xyz, r5.xyzz, r0.xyzz
aaaaaaaaacaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, r4.xyzz
aaaaaaaaabaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v1, a2
adaaaaaaafaaadacadaaaaoeaaaaaaaabbaaaaoeabaaaaaa mul r5.xy, a3, c17
abaaaaaaaaaaadaeafaaaafeacaaaaaabbaaaaooabaaaaaa add v0.xy, r5.xyyy, c17.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 6 to 6, TEX: 1 to 1
//   d3d9 - ALU: 5 to 5, TEX: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 6 ALU, 1 TEX
PARAM c[2] = { program.local[0..1] };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
MUL R0, R0, fragment.texcoord[1];
ADD R1.xyz, R0, c[0];
MAD result.color.xyz, R0, fragment.texcoord[3], R1;
MOV result.color.w, R0;
END
# 6 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 5 ALU, 1 TEX
dcl_2d s0
dcl t0.xy
dcl t1
dcl t3.xyz
texld r0, t0, s0
mul r0, r0, c1
mul r0, r0, t1
add_pp r1.xyz, r0, c0
mad_pp r0.xyz, r0, t3, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeabaaaaaa mul r0, r0, c1
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeaeaaaaaa mul r0, r0, v1
abaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa add r1.xyz, r0.xyzz, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r0.xyz, r0.xyzz, v3
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}

#LINE 50

	}
	
	Fallback "Cloud/Cloud"
}