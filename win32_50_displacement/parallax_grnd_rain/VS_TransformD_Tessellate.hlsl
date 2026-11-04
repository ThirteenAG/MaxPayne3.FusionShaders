cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float3 r2;
	float3 r3;
	o.texcoord8.xyz = i.position.xyz;
	o.texcoord8.w = 1;
	r0.x = dot(i.color.xy, globalDayNightEffects.zw);
	r0.x = r0.x * globalScalars.z + -1;
	r0.x = gAmbientOcclusionEffect.x * r0.x + 1;
	o.color.xy = r0.xx * gAmbientOcclusionEffect.yy;
	o.color.zw = i.color.zw;
	o.texcoord = i.texcoord.xy;
	r0.xyz = i.normal.yyy * gWorld[1].xyz;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	o.texcoord1.xyz = r0.xyz;
	o.texcoord1.w = 1;
	r1 = i.position.yyy * gWorld[1].xyz;
	r1 = i.position.xxx * gWorld[0].xyz + r1.xyz;
	r1 = i.position.zzz * gWorld[2].xyz + r1.xyz;
	r1 = r1.xyz + gWorld[3].xyz;
	r2 = -(r1.xyz) + gViewInverse[3].xyz;
	o.texcoord6.xyz = r1.xyz;
	o.texcoord3 = r2.xyz;
	r1 = i.tangent.yyy * gWorld[1].xyz;
	r1 = i.tangent.xxx * gWorld[0].xyz + r1.xyz;
	r1 = i.tangent.zzz * gWorld[2].xyz + r1.xyz;
	r1 = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1 = r0.www * r1.xyz;
	o.texcoord4 = r1.xyz;
	r3 = r0.yzx * r1.zxy;
	r3 = r1.yzx * r0.zxy + -(r3.xyz);
	o.texcoord7.z = dot(r0.xyz, r2.xyz);
	o.texcoord7.x = dot(r1.xyz, r2.xyz);
	r0.xyz = r3.xyz * i.tangent.www;
	o.texcoord5 = r0.xyz;
	o.texcoord7.y = dot(r0.xyz, r2.xyz);
	o.texcoord6.w = 1;
	o.texcoord7.w = 1;

	return o;
}
