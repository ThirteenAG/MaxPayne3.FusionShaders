float4 gDeferredLightColourAndIntensity : register(c214);
float3 gDeferredLightPosition : register(c203);
float4 gDeferredLightRadiusProjShearParams : register(c206);
float4 gDeferredLightVolumeParams : register(c218);
float gDeferredVolumeRadiusScale : register(c209);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = 1E-05 + position.xyz;
	r1.xyz = normalize(r0.xyz);
	r0.x = gDeferredLightRadiusProjShearParams.x;
	r0.x = r0.x * gDeferredVolumeRadiusScale.x;
	r0.x = r0.x * 0.662;
	r0.xyz = r0.xxx * r1.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = r0.w * 100;
	r0.w = min(r0.w, 1);
	r0.xyz = r0.xyz * r0.www + gDeferredLightPosition.xyz;
	o.texcoord1 = r0.xyz + -gViewInverse[3].xyz;
	r1.xyz = gViewInverse[3].xyz;
	o.texcoord.xyz = r1.xyz + -gDeferredLightPosition.xyz;
	r0.w = gDeferredLightColourAndIntensity.w;
	r0.w = r0.w * gDeferredLightVolumeParams.x;
	r0.w = r0.w * 0.25;
	o.texcoord2 = r0.www * gDeferredLightColourAndIntensity.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord3 = r0.xyz;
	r0 = r1 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord.w = r0.w;

	return o;
}
