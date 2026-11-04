float4 gDeferredLightColourAndIntensity : register(c214);
float gDeferredLightConeAngle : register(c211);
float3 gDeferredLightDirection : register(c204);
float3 gDeferredLightPosition : register(c203);
float4 gDeferredLightRadiusProjShearParams : register(c206);
float3 gDeferredLightTangent : register(c205);
float4 gDeferredLightVolumeParams : register(c218);
float gDeferredVolumeRadiusScale : register(c209);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.x = saturate(-position.z);
	r0.x = -r0.x + 1;
	r0.x = r0.x * gDeferredLightConeAngle.x;
	r0.x = r0.x * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	r1.x = cos(r0.x);
	r0.x = r1.x * -r1.x + 1;
	r0.yz = position.xy * position.xy;
	r0.y = r0.z + r0.y;
	r0.y = 1 / r0.y;
	r0.x = r0.y * r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * gDeferredVolumeRadiusScale.x;
	r0.xy = r0.xx * position.xy;
	r2 = gDeferredLightDirection.xyz;
	r1.yzw = r2.yzx * gDeferredLightTangent.zxy;
	r1.yzw = gDeferredLightTangent.yzx * r2.zxy + -r1.yzw;
	r0.yzw = r0.yyy * r1.yzw;
	r0.xyz = gDeferredLightTangent.xyz * r0.xxx + r0.yzw;
	r0.xyz = gDeferredLightDirection.xyz * r1.xxx + r0.xyz;
	r0.w = abs(position.y) + abs(position.x);
	r0.w = (r0.w >= 0.99) ? 1 : 0;
	r0.xyz = r0.xyz * r0.www;
	r1.x = gDeferredVolumeRadiusScale.x;
	r0.w = r1.x * gDeferredLightRadiusProjShearParams.x;
	r0.w = r0.w * 0.662;
	r0.xyz = r0.www * r0.xyz;
	o.texcoord1.w = r0.w;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = r0.w * 100;
	r0.w = min(r0.w, 1);
	r1.xyz = r0.xyz * r0.www + gDeferredLightPosition.xyz;
	r0.xyz = r0.www * r0.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x + 1E-05;
	o.texcoord1.xyz = r1.xyz + -gViewInverse[3].xyz;
	r0.w = gDeferredLightColourAndIntensity.w;
	r0.y = r0.w * gDeferredLightVolumeParams.x;
	r0.y = r0.y * 0.25;
	o.texcoord2.xyz = r0.yyy * gDeferredLightColourAndIntensity.xyz;
	o.texcoord4.xyz = r2.xyz * r0.xxx + gDeferredLightPosition.xyz;
	o.texcoord2.w = r0.x;
	r0.xyz = gDeferredLightPosition.xyz;
	r0.xyz = -r0.xyz + gViewInverse[3].xyz;
	r2 = r0.xyz + 1E-05;
	o.texcoord.xyz = r0.xyz;
	r0.xyz = normalize(r2.xyz);
	r0.x = dot(gDeferredLightDirection.xyz, r0.xyz);
	r0.x = abs(r0.x) + 1E-05;
	r0.x = log2(r0.x);
	r0.x = r0.x * 2.50001;
	o.texcoord4.w = exp2(r0.x);
	r0 = r1.y * gWorldViewProj[1];
	r0 = r1.x * gWorldViewProj[0] + r0;
	r0 = r1.z * gWorldViewProj[2] + r0;
	o.texcoord3 = r1.xyz;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord.w = r0.w;
	o.texcoord5 = 0;

	return o;
}
