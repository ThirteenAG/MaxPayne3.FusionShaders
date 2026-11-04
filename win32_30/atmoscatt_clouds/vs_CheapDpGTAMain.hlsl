float3 AzimuthColor : register(c134);
float3 AzimuthColorEast : register(c141);
float AzimuthHeight : register(c142);
float AzimuthStrength : register(c145);
float3 SkyColor : register(c133);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldView : register(c4);

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
	float3 r3;
	float3 r4;
	r0.xyz = gWorldView[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorldView[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldView[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldView[3].xyz;
	r0.w = r0.z + 512;
	r0.w = dot(r0.xyw, r0.xyw);
	r0.w = rsqrt(r0.w);
	r1.x = 1 / r0.w;
	r1.y = r1.x + 1;
	r1.y = 1 / r1.y;
	r2.z = -r1.y + 1;
	r3.z = 1;
	o.texcoord.z = r2.z * -r3.z + 1;
	r1.yzw = gWorld[1].xyz * i.position.yyy;
	r1.yzw = i.position.xxx * gWorld[0].xyz + r1.yzw;
	r1.yzw = i.position.zzz * gWorld[2].xyz + r1.yzw;
	r1.yzw = i.position.www * gWorld[3].xyz + r1.yzw;
	r1.yzw = r1.yzw + -gWorld[3].xyz;
	r4 = r1.yzw + 1E-05;
	o.texcoord1 = r1.yzw;
	r1.y = dot(r4.xyz, r4.xyz);
	r1.y = rsqrt(r1.y);
	r1.yz = r1.yy * r4.xy;
	r1.z = saturate(r1.z * AzimuthHeight.x);
	r1.y = r1.y * 0.5 + 0.5;
	r1.z = -r1.z + 1;
	r1.z = r1.z * AzimuthStrength.x;
	r4 = AzimuthColorEast.xyz;
	r4 = -r4.xyz + AzimuthColor.xyz;
	r4 = r1.yyy * r4.xyz + AzimuthColorEast.xyz;
	o.texcoord5 = r4.xyz * r1.zzz + SkyColor.xyz;
	r0.z = r0.z + 512;
	r0.w = r0.z * -r0.w + 1;
	r1.yz = r0.zz * float2(0.0004, -0.0004);
	r0.z = r0.w * r1.x;
	r0.z = 1 / r0.z;
	r2.xy = r0.zz * r0.xy;
	r0.x = max(r1.z, -1);
	r1.y = saturate(r1.y);
	r3.y = r1.y * 0.2 + 1;
	r0.x = min(r0.x, 1);
	r3.x = r0.x * -0.2 + 1;
	r0.xyz = r2.xyz * r3.xyz;
	o.position.xyz = r0.xyz;
	o.position.w = 1;
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord2 = 0;
	o.texcoord3 = 0;
	o.texcoord4 = 0;

	return o;
}
