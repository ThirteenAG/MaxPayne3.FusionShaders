cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_usedir : register(b1)
{
	bool gUseDirectional : packoffset(c0);
};

cbuffer PtxGPUAttribs : register(b4)
{
	float gMotionBlur : packoffset(c0);
	float4 gRadius : packoffset(c1);
	float2 gLifeFade : packoffset(c2);
	float4 gTextureAnimation : packoffset(c3);
	float4 gColorTint : packoffset(c4);
};

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = dot(gViewInverse[0].xyz, gViewInverse[0].xyz);
	r0.x = rsqrt(r0.x);
	r0.xyz = r0.xxx * gViewInverse[0].xyz;
	r0.xyz = r0.xyz * gRadius.xxx;
	r0.w = dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz));
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * -(gViewInverse[1].xyz);
	r1.xyz = r1.xyz * gRadius.xxx;
	r2.xy = i.texcoord2.xy + float2(-0.5, -0.5);
	r1.xyz = r1.xyz * r2.yyy;
	r0.xyz = r2.xxx * r0.xyz + r1.xyz;
	r0.w = dot(i.texcoord1.xyz, i.texcoord1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * i.texcoord1.xyz;
	r2.yzw = -(i.texcoord.yzx) + gViewInverse[3].yzx;
	r3 = r1.zxy * r2.yzw;
	r2.yzw = r1.yzx * r2.zwy + -(r3.xyz);
	r0.w = dot(r2.yzw, r2.yzw);
	r0.w = rsqrt(r0.w);
	r2.yzw = r0.www * r2.yzw;
	r2.yzw = r2.yzw * gRadius.xxx;
	r3 = i.texcoord1.xyz * gMotionBlur;
	r1.xyz = gRadius.xxx * r1.xyz + r3.xyz;
	r0.w = -(i.texcoord2.y) + 0.699999988;
	r1.xyz = -(r1.xyz) * r0.www;
	r1.xyz = r2.xxx * r2.yzw + r1.xyz;
	r0.xyz = (gUseDirectional != 0) ? r1.xyz : r0.xyz;
	r0.xyz = r0.xyz + i.texcoord.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.sv_position = r0 + gWorldViewProj[3];
	o.color = gColorTint;
	r0.x = i.texcoord.w * gTextureAnimation.x + -(gTextureAnimation.y);
	r0.x = trunc(r0.x);
	r0.x = saturate(r0.x * gTextureAnimation.z);
	o.texcoord.x = gTextureAnimation.z * i.texcoord2.x + r0.x;
	o.texcoord.y = i.texcoord2.y;

	return o;
}
