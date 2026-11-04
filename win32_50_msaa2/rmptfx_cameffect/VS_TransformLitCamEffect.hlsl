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
};

cbuffer ParticleCamData : register(b4)
{
	float gSuperAlpha : packoffset(c0);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float3 r0;
	float3 r1;
	float3 r2;
	float2 r3;
	float r4;
	r0.y = globalScreenSize.x / globalScreenSize.y;
	r1.z = 0;
	r0.xz = float2(1, 1);
	r2.xy = i.position.xy;
	r2.z = 0;
	r3.x = sin(i.normal.z);
	r4 = cos(i.normal.z);
	r3 = r3.xx * i.normal.yx;
	r1.x = i.normal.x * r4.x + -(r3.x);
	r1.y = i.normal.y * r4.x + r3.y;
	o.sv_position.xyz = r1.xyz * r0.xyz + r2.xyz;
	o.sv_position.w = 1;
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	o.texcoord.xyz = i.color.xyz;
	o.texcoord1 = i.texcoord.xy;
	o.texcoord2 = i.texcoord3;

	return o;
}
