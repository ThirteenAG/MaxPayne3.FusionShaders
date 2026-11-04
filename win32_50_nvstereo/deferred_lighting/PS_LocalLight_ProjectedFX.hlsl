cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer DeferredLight : register(b4)
{
	float gDeferredLightType : packoffset(c0);
	float3 gDeferredLightPosition : packoffset(c0.y);
	float3 gDeferredLightDirection : packoffset(c1);
	float3 gDeferredLightTangent : packoffset(c2);
	float4 gDeferredLightRadiusProjShearParams : packoffset(c3);
	float gDeferredLightInvSqrRadius : packoffset(c4);
	float gDeferredVolumeRadiusScale : packoffset(c4.y);
	float gDeferredLightConeAngleI : packoffset(c4.z);
	float gDeferredLightConeAngle : packoffset(c4.w);
	float gDeferredLightConeOffset : packoffset(c5);
	float gDeferredLightConeScale : packoffset(c5.y);
	float4 gDeferredLightColourAndIntensity : packoffset(c6);
	float4 gooDeferredLightScreenSize : packoffset(c7);
	float4 gDeferredProjParams : packoffset(c8);
};

SamplerState StereoParmsTex : register(s9);
Texture2D<uint4> gbufferStencilTexture : register(t2);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D gbufferTexture1 : register(t12);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float3 r2;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.y = gbufferStencilTexture.Load(r0.xyw).y;
	r0.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r1.zw = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(-(asfloat(r1.w)) + asfloat(r1.x));
		r1.x = asint(asfloat(r1.x) * asfloat(r1.z));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r1.xzw = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r2 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r1.xzw = asint(r2.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xzw = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r1.xzw));
	r0.w = r1.y & 7;
	r0.w = (r0.w == 1) ? -1 : 0;
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.z));
	r1.xyz = asint(asfloat(r1.xzw) + -(i.texcoord2.xyz));
	r0.y = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r0.y = asint(saturate(-(asfloat(r0.y)) * i.texcoord1.y + 1));
	r0.y = asint(asfloat(r0.y) + 0.00000999999975);
	r0.y = asint(log2(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * 2.00001001);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) + -0.333333343);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.z = asint(-(abs(asfloat(r1.z))) * 2 + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(asfloat(r0.z) + 0.00000999999975);
	r0.z = asint(log2(asfloat(r0.z)));
	r0.yz = asint(asfloat(r0.yz) * float2(1.5, 2.00001001));
	r0.z = asint(exp2(asfloat(r0.z)));
	r1.xyz = asint(asfloat(r0.yyy) * i.texcoord4.xyz);
	r1.xyz = asint(asfloat(r0.zzz) * asfloat(r1.xyz));
	r0.xyz = asint(abs(asfloat(r0.xxx)) * asfloat(r1.xyz));
	r0.w = (r0.w != 0) ? 0 : 1065353216;
	o.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	o.w = 1;

	return o;
}
