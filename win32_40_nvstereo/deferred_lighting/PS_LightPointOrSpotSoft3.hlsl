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
Texture2D gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);

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
	int4 r2;
	int4 r3;
	float4 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r2 = gbufferStencilTexture.Load(r0.xyw);
	r3 = asint(gbufferTexture0.Load(r0.xyw));
	r4 = gbufferTexture2.Load(r0.xyw);
	r0 = asint(gbufferTexture1.Load(r0.xyz));
	r1.yzw = asint(asfloat(r3.xyz) * asfloat(r3.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r3 = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)));
		r1.x = asint(asfloat(r1.x) + -(asfloat(r3.y)));
		r1.x = asint(asfloat(r1.x) * asfloat(r3.x));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r2.xzw = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r3 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
		r2.xzw = asint(asfloat(r3.xyz) + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xzw = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r2.xzw));
	r0.w = r2.y & 7;
	r0.w = (r0.w == 1) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.x = asint(r4.y * r4.y);
	r1.x = asint(asfloat(r1.x) * asfloat(r1.x));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.y = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r2.y = asint(rsqrt(asfloat(r2.y)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r2.yyy));
	r3 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
	r3.xyz = asint(asfloat(r3.xyz) + gViewInverse[3].xyz);
	r3.xyz = asint(asfloat(r2.xzw) + -(asfloat(r3.xyz)));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.y = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r2.y = asint(rsqrt(asfloat(r2.y)));
	r3.xyz = asint(asfloat(r2.yyy) * asfloat(r3.xyz));
	r2.xyz = asint(-(asfloat(r2.xzw)) + i.texcoord2.xyz);
	r4.yzw = asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = asint(dot(r4.yzw, r4.yzw));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r4.yzw = asfloat(r2.www) * r4.yzw;
	r2.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r2.x = asint(sqrt(asfloat(r2.x)));
	r2.x = asint(saturate(-(asfloat(r2.x)) * gDeferredLightRadiusProjShearParams.y + 1));
	r2.y = asint(dot(r4.yzw, i.texcoord3.xyz));
	r2.y = asint(saturate(asfloat(r2.y) * i.texcoord1.w + i.texcoord1.z));
	r2.x = asint(asfloat(r2.y) * asfloat(r2.x));
	r2.y = asint(dot(asfloat(r3.xyz), asfloat(r0.xyz)));
	r2.y = asint(asfloat(r2.y) + asfloat(r2.y));
	r2.yzw = asint(asfloat(r0.xyz) * -(asfloat(r2.yyy)) + asfloat(r3.xyz));
	r3.x = asint(dot(r4.yzw, asfloat(r2.yzw)));
	r3.y = asint(dot(r4.yzw, asfloat(r0.xyz)));
	r0.xyz = asint(asfloat(r2.xxx) * i.texcoord4.xyz);
	r2.x = asint(asfloat(r3.y) + 0.5);
	r2.x = asint(saturate(asfloat(r2.x) * 0.25));
	r2.yzw = asint(saturate(asfloat(r3.yxy)));
	r2.x = asint(asfloat(r2.y) + asfloat(r2.x));
	r3.xyz = asint(asfloat(r0.xyz) * asfloat(r2.xxx));
	r2.x = asint(asfloat(r2.z) + 0.0000199999995);
	r1.x = asint(asfloat(r1.x) * 196 + 0.00000999999975);
	r2.x = asint(log2(asfloat(r2.x)));
	r1.x = asint(asfloat(r1.x) * asfloat(r2.x));
	r1.x = asint(exp2(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r1.x = asint(saturate(asfloat(r2.w) * 2 + -0.5));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r1.xyz = asint(asfloat(r1.yzw) * asfloat(r3.xyz));
	r0.xyz = asint(r4.xxx * asfloat(r0.xyz) + asfloat(r1.xyz));
	o.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	o.w = 1;

	return o;
}
