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
Texture2DMS<uint4> gbufferStencilTexture : register(t2);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2DMS<float> gbufferTextureDepth : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float2 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r1.y = gbufferStencilTexture.Load(r0.xy, i.sv_sampleindex).y;
	r2.xyz = gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz;
	r3.xyz = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xyz;
	r0.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r2.xyz = r2.xyz * r2.xyz;
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
		r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r1.xzw = asint(r4.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xzw = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r1.xzw));
	r0.w = r1.y & 8;
	r0.w = (r0.w == 8) ? -1 : 0;
	r1.y = asint(r3.y * r3.y);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.w = dot(asfloat(r0.xyz), asfloat(r0.xyz));
	r2.w = rsqrt(r2.w);
	r0.xyz = asint(asfloat(r0.xyz) * r2.www);
	r2.w = r3.z * r3.z + 0.5;
	r2.w = min(r2.w, 1);
	r0.w = (r0.w != 0) ? 0 : asint(r2.w);
	r3.yzw = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r3.yzw = r3.yzw + gViewInverse[3].xyz;
	r3.yzw = asfloat(r1.xzw) + -(r3.yzw);
	r3.yzw = r3.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = dot(r3.yzw, r3.yzw);
	r2.w = rsqrt(r2.w);
	r3.yzw = r2.www * r3.yzw;
	r1.xzw = asint(-(asfloat(r1.xzw)) + i.texcoord2.xyz);
	r4 = asfloat(r1.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = dot(r4.xyz, r4.xyz);
	r2.w = rsqrt(r2.w);
	r4 = r2.www * r4.xyz;
	r1.x = asint(dot(asfloat(r1.xzw), asfloat(r1.xzw)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(saturate(-(asfloat(r1.x)) * gDeferredLightRadiusProjShearParams.y + 1));
	r1.z = asint(dot(r4.xyz, i.texcoord3.xyz));
	r1.z = asint(saturate(asfloat(r1.z) * i.texcoord1.w + i.texcoord1.z));
	r1.x = asint(asfloat(r1.z) * asfloat(r1.x));
	r1.z = asint(dot(r3.yzw, asfloat(r0.xyz)));
	r1.z = asint(asfloat(r1.z) + asfloat(r1.z));
	r3.yzw = asfloat(r0.xyz) * -(asfloat(r1.zzz)) + r3.yzw;
	r5.x = dot(r4.xyz, r3.yzw);
	r5.y = dot(r4.xyz, asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r1.xxx) * i.texcoord4.xyz);
	r1.x = asint(r5.y + 0.5);
	r1.x = asint(saturate(asfloat(r1.x) * 0.25));
	r3.yzw = saturate(r5.yxy);
	r1.x = asint(asfloat(r1.x) + r3.y);
	r1.xzw = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r2.w = r3.z + 0.0000199999995;
	r1.y = asint(asfloat(r1.y) * 196 + 0.00000999999975);
	r2.w = log2(r2.w);
	r1.y = asint(asfloat(r1.y) * r2.w);
	r1.y = asint(exp2(asfloat(r1.y)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.yyy));
	r1.y = asint(saturate(r3.w * 2 + -0.5));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.yyy));
	r1.xyz = asint(asfloat(r1.xzw) * r2.xyz);
	r0.xyz = asint(r3.xxx * asfloat(r0.xyz) + asfloat(r1.xyz));
	o.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	o.w = 1;

	return o;
}
