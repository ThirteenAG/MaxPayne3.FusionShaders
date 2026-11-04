float3 AzimuthColor : register(c134);
float3 AzimuthColorEast : register(c141);
float AzimuthHeight : register(c142);
float AzimuthStrength : register(c145);
float CloudShadowOffset : register(c156);
float4 CloudThicknessEdgeSmoothDetailScaleStrength : register(c157);
float2 DetailOffset : register(c170);
float2 GalaxyOffset : register(c161);
float3 SkyColor : register(c133);
float StarFieldUVRepeat : register(c160);
float4 SunDirection : register(c132);
float4 TopCloudBiasDetailThresholdHeight : register(c152);
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
	float4 r2;
	float4 r3;
	r0.x = saturate(-i.position.y);
	r0.x = -r0.x + i.position.y;
	r0.yzw = r0.xxx * gWorld[1].xyz;
	r1 = r0.x * gWorldViewProj[1];
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.z * gWorldViewProj[2] + r1;
	r1 = i.position.w * gWorldViewProj[3] + r1;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.yzw;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = i.position.www * gWorld[3].xyz + r0.xyz;
	r0.xyz = r0.xyz + -gWorld[3].xyz;
	r2.xyz = r0.xyz + 1E-05;
	o.texcoord1 = r0.xyz;
	r0.x = dot(r2.xyz, r2.xyz);
	r0.x = rsqrt(r0.x);
	r3.xyz = r0.xxx * r2.xyz;
	r0.xy = r2.xz * -r0.xx + SunDirection.xz;
	r3.w = r3.y * 1.5;
	r2.xyz = r3.xwz + float3(1E-05, 0.50001, 1E-05);
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r0.zw = r0.zz * r2.xz;
	r2.xy = abs(r0.zw) * -0.0187293 + 0.074261;
	r2.xy = r2.xy * abs(r0.zw) + -0.2121144;
	r2.xy = r2.xy * abs(r0.zw) + 1.5707288;
	r2.zw = -abs(r0.zw) + 1;
	r0.zw = (r0.zw < -r0.zw) ? 1 : 0;
	r2.z = rsqrt(r2.z);
	r2.w = rsqrt(r2.w);
	r2.w = 1 / r2.w;
	r2.z = 1 / r2.z;
	r2.xy = r2.zw * r2.xy;
	r2.z = r2.x * -2 + 3.1415927;
	r0.z = r2.z * r0.z + r2.x;
	r0.z = -r0.z + 1.5707964;
	r2.w = 0.31773266;
	r3.z = r0.z * r2.w + GalaxyOffset.x;
	r0.z = r2.y * -2 + 3.1415927;
	r0.z = r0.z * r0.w + r2.y;
	r0.z = -r0.z + 1.5707964;
	r3.w = r0.z * r2.w + GalaxyOffset.y;
	r0.zw = r3.zw + 0.5;
	o.texcoord3.xy = r0.zw * StarFieldUVRepeat.xx;
	o.texcoord3.zw = r0.zw;
	r2.xy = float2(0.5, 0.1);
	r0.z = r2.y * CloudShadowOffset.x;
	r0.xy = r0.xy * r0.zz;
	r0.zw = i.texcoord.xy * 2 + -1;
	r0.zw = r0.zw * r0.zw;
	r0.z = r0.w + r0.z;
	r0.z = -r0.z + 1;
	o.texcoord2.xy = r0.xy * r0.zz + i.texcoord.xy;
	r0.xy = -0.5 + i.texcoord.xy;
	r0.zw = r0.xy * r0.xy;
	r0.z = r0.w + r0.z;
	r0.w = r0.z + 1E-05;
	r0.w = rsqrt(r0.w);
	r2.yz = r0.ww * r0.xy;
	r0.w = (-r0.z >= r0.z) ? 1 : 0;
	r2.yz = r0.ww * -r2.yz + r2.yz;
	r0.zw = r0.zz * r2.yz;
	r2.z = CloudThicknessEdgeSmoothDetailScaleStrength.z;
	o.texcoord2.zw = r0.zw * r2.zz + DetailOffset.xy;
	r0.zw = r0.xy * TopCloudBiasDetailThresholdHeight.ww;
	o.texcoord4.xy = r0.xy * TopCloudBiasDetailThresholdHeight.ww + r2.xx;
	r0.xy = r0.zw * r0.zw;
	r0.x = r0.y + r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.texcoord4.z = -r0.x + 1;
	r0.x = 1 / r1.w;
	o.texcoord.z = r1.z * -r0.x + 1;
	o.position = r1;
	r0.x = saturate(r3.y * AzimuthHeight.x);
	r0.y = r3.x * 0.5 + 0.5;
	r0.x = -r0.x + 1;
	r0.x = r0.x * AzimuthStrength.x;
	r1.xyz = AzimuthColorEast.xyz;
	r1.xyz = -r1.xyz + AzimuthColor.xyz;
	r0.yzw = r0.yyy * r1.xyz + AzimuthColorEast.xyz;
	o.texcoord5 = r0.yzw * r0.xxx + SkyColor.xyz;
	o.texcoord.xy = i.texcoord.xy;

	return o;
}
