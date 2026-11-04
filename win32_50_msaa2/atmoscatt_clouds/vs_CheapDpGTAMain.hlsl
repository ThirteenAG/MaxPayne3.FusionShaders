cbuffer _Globals : register(b1)
{
	float4 SunDirection : packoffset(c132);
	float3 SkyColor : packoffset(c133);
	float3 AzimuthColor : packoffset(c134);
	float3 SunColor : packoffset(c135);
	float UnderLightStrength : packoffset(c136);
	float3 gtaSkyDomeFade : packoffset(c137);
	float3 gtaWaterColor : packoffset(c138);
	float MoonGlow : packoffset(c139);
	float2 SunAxias : packoffset(c140);
	float3 AzimuthColorEast : packoffset(c141);
	float AzimuthHeight : packoffset(c142);
	float4 CloudColor : packoffset(c143);
	float4 SunsetColor : packoffset(c144);
	float AzimuthStrength : packoffset(c145);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
};

struct VS_IN
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float3 r2;
	r0.xyz = i.position.yyy * gWorldView[1].xyz;
	r0.xyz = i.position.xxx * gWorldView[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldView[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldView[3].xyz;
	r0.w = r0.z + 512;
	r0.w = dot(r0.xyw, r0.xyw);
	r0.w = sqrt(r0.w);
	r0.z = r0.z + 512;
	r1.x = r0.z / r0.w;
	r1.yz = r0.zz * float2(0.000399999990, -0.000399999990);
	r0.z = -(r1.x) + 1;
	r0.z = r0.z * r0.w;
	r0.w = r0.w + 1;
	r0.w = 1 / r0.w;
	r2.z = -(r0.w) + 1;
	r0.z = 1 / r0.z;
	r2.xy = r0.zz * r0.xy;
	r0.x = max(r1.z, -1);
	r1.y = saturate(r1.y);
	r1.y = r1.y * 0.200000003 + 1;
	r0.x = min(r0.x, 1);
	r1.x = -(r0.x) * 0.200000003 + 1;
	r1.z = 1;
	r0.xyz = r1.xyz * r2.xyz;
	o.texcoord.z = -(r2.z) * r1.z + 1;
	o.sv_position.xyz = r0.xyz;
	o.sv_position.w = 1;
	o.texcoord.xy = i.texcoord.xy;
	r0.xyz = i.position.yyy * gWorld[1].xyz;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = i.position.www * gWorld[3].xyz + r0.xyz;
	r0.xyz = r0.xyz + -(gWorld[3].xyz);
	o.texcoord1 = r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	o.texcoord2 = float4(0, 0, 0, 0);
	o.texcoord3 = float4(0, 0, 0, 0);
	o.texcoord4 = float3(0, 0, 0);
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r0.y = saturate(r0.y * AzimuthHeight);
	r0.x = r0.x * 0.5 + 0.5;
	r0.y = -(r0.y) + 1;
	r0.y = r0.y * AzimuthStrength;
	r1 = AzimuthColor.xyz + -(AzimuthColorEast.xyz);
	r0.xzw = r0.xxx * r1.xyz + AzimuthColorEast.xyz;
	o.texcoord5 = r0.xzw * r0.yyy + SkyColor.xyz;

	return o;
}
