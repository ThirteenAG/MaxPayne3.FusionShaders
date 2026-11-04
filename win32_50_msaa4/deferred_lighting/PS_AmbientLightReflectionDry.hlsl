cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
};

Texture2DMS<float4> deferredLightTexture0P : register(t3);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float3 r2;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.xyz = gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz;
	r1.xyz = r1.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.xyz = r1.www * r1.xyz;
	r1.w = dot(gLightAmbientDir1.xyz, r1.xyz);
	r1.x = dot(gLightAmbientDir0.xyz, r1.xyz);
	r1.xy = saturate(r1.xw + gLightAmbientDir0.ww);
	r1.yzw = r1.yyy * gLightAmbient1.xyz;
	r1.xyz = r1.xxx * gLightAmbient0.xyz + r1.yzw;
	r1.w = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).z;
	r1.xyz = r1.www * r1.xyz;
	r1.w = dot(r1.xyz, float3(0.333333343, 0.333333343, 0.333333343));
	r1.w = r1.w + 0.0149999997;
	r2 = deferredLightTexture0P.Load(r0.xy, i.sv_sampleindex).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r2 = r2.xyz * r2.xyz;
	r2 = r2.xyz * float3(16, 16, 16);
	r2 = r1.www * r2.xyz;
	o.xyz = asfloat(r0.xyz) * r1.xyz + r2.xyz;
	o.w = 1;

	return o;
}
