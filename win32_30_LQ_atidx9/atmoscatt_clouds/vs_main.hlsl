float3 AzimuthColor : register(c134);
float3 AzimuthColorEast : register(c141);
float AzimuthHeight : register(c142);
float AzimuthStrength : register(c145);
float3 SkyColor : register(c133);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
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
	float4 r1;
	r0.x = saturate(-i.position.y);
	r0.x = -r0.x + i.position.y;
	r1 = r0.x * gWorldViewProj[1];
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = i.position.www * gWorld[3].xyz + r0.xyz;
	r0.xyz = r0.xyz + -gWorld[3].xyz;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.z * gWorldViewProj[2] + r1;
	r1 = i.position.w * gWorldViewProj[3] + r1;
	r0.w = 1 / r1.w;
	o.texcoord.z = r1.z * -r0.w + 1;
	o.position = r1;
	r1.xyz = r0.xyz + 1E-05;
	o.texcoord1 = r0.xyz;
	r0.x = dot(r1.xyz, r1.xyz);
	r0.x = rsqrt(r0.x);
	r0.xy = r0.xx * r1.xy;
	r0.y = saturate(r0.y * AzimuthHeight.x);
	r0.x = r0.x * 0.5 + 0.5;
	r0.y = -r0.y + 1;
	r0.y = r0.y * AzimuthStrength.x;
	r1.xyz = AzimuthColorEast.xyz;
	r1.xyz = -r1.xyz + AzimuthColor.xyz;
	r0.xzw = r0.xxx * r1.xyz + AzimuthColorEast.xyz;
	o.texcoord5 = r0.xzw * r0.yyy + SkyColor.xyz;
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord2 = 0;
	o.texcoord3 = 0;
	o.texcoord4 = 0;

	return o;
}
