float4 gDeferredLightColourAndIntensity : register(c214);
float3 gDeferredLightDirection : register(c204);
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
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main()
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = gDeferredLightPosition.xyz;
	o.texcoord1.xyz = r0.xyz + -gViewInverse[3].xyz;
	r1.x = gDeferredLightRadiusProjShearParams.x;
	r0.w = r1.x * gDeferredVolumeRadiusScale.x;
	o.texcoord1.w = r0.w * 0.662;
	r0.w = gDeferredLightColourAndIntensity.w;
	r0.w = r0.w * gDeferredLightVolumeParams.x;
	r0.w = r0.w * 0.25;
	o.texcoord2.xyz = r0.www * gDeferredLightColourAndIntensity.xyz;
	r1.z = 1E-05;
	o.texcoord4.xyz = gDeferredLightDirection.xyz * r1.zzz + r0.xyz;
	r1.xyz = -r0.xyz + gViewInverse[3].xyz;
	r2 = r1.xyz + 1E-05;
	o.texcoord.xyz = r1.xyz;
	r1.xyz = normalize(r2.xyz);
	r0.w = dot(gDeferredLightDirection.xyz, r1.xyz);
	r0.w = abs(r0.w) + 1E-05;
	r0.w = log2(r0.w);
	r0.w = r0.w * 2.50001;
	o.texcoord4.w = exp2(r0.w);
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord.w = r0.w;
	o.texcoord2.w = 1E-05;
	o.texcoord3 = gDeferredLightPosition.xyz;
	o.texcoord5 = 0;

	return o;
}
