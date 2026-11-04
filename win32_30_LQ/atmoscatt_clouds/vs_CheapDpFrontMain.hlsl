float3 AzimuthColor : register(c134);
float3 AzimuthColorEast : register(c141);
float AzimuthHeight : register(c142);
float AzimuthStrength : register(c145);
float3 SkyColor : register(c133);
float dpMapFarClip : register(c177);
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
	float3 r2;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = 1 / dpMapFarClip.x;
	o.texcoord.z = r0.z * -r1.x + 1;
	r1.x = r0.z * r1.x;
	o.position.z = r1.x;
	r1.xyz = gWorld[1].xyz * i.position.yyy;
	r1.xyz = i.position.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = i.position.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = i.position.www * gWorld[3].xyz + r1.xyz;
	r1.xyz = r1.xyz + -gWorld[3].xyz;
	r2 = r1.xyz + 1E-05;
	o.texcoord1 = r1.xyz;
	r1.x = dot(r2.xyz, r2.xyz);
	r1.x = rsqrt(r1.x);
	r1.xy = r1.xx * r2.xy;
	r1.y = saturate(r1.y * AzimuthHeight.x);
	r1.x = r1.x * 0.5 + 0.5;
	r1.y = -r1.y + 1;
	r1.y = r1.y * AzimuthStrength.x;
	r2 = AzimuthColorEast.xyz;
	r2 = -r2.xyz + AzimuthColor.xyz;
	r1.xzw = r1.xxx * r2.xyz + AzimuthColorEast.xyz;
	o.texcoord5 = r1.xzw * r1.yyy + SkyColor.xyz;
	r0.w = 1 / abs(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.z = r0.z * r0.w + 1;
	r0.xy = r0.ww * r0.xy;
	r0.z = 1 / r0.z;
	r0.xyz = r0.zzz * r0.xyx;
	o.position.xyw = r0.xyz * float3(0.5, 1, 0) + float3(-0.5, 0, 1);
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord2 = 0;
	o.texcoord3 = 0;
	o.texcoord4 = 0;

	return o;
}
