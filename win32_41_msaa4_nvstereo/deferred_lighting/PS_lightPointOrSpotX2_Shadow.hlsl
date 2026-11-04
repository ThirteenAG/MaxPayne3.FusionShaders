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

SamplerState gDeferredLightShadowMap0 : register(s4);
SamplerState gDeferredLightShadowMap1 : register(s5);
SamplerState StereoParmsTex : register(s9);
Texture2D gDeferredLightShadowMap0_tex : register(t4);
Texture2D gDeferredLightShadowMap1_tex : register(t5);
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
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r2.xy = asint(gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xy);
	r0.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2.zw = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(asfloat(r1.x) + -(asfloat(r2.w)));
		r1.x = asint(asfloat(r1.x) * asfloat(r2.z));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r3.xyz = -(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz;
	} else {
		r4.xyz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r3.xyz = r4.xyz + gViewInverse[3].xyz;
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3.xyz = -(i.texcoord.xyz) * asfloat(r0.www) + r3.xyz;
	r0.w = asint(asfloat(r2.y) * asfloat(r2.y));
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r1.x = asint(sqrt(i.texcoord1.w));
	r2.yzw = asint(r3.yzx + -(i.texcoord1.yzx));
	r4.xyz = asfloat(r2.yzw) * float3(1, -1, 1);
	r2.y = (0 < asfloat(r2.w)) ? -1 : 0;
	r2.yz = (r2.yy != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r4.w = -(abs(r4.z));
	r2.w = asint(dot(r4.xyw, r4.xyw));
	r2.w = asint(sqrt(asfloat(r2.w)));
	r3.w = abs(r4.z) + asfloat(r2.w);
	r3.w = 1 / r3.w;
	r4.xy = r3.ww * r4.xy;
	r1.x = asint(asfloat(r1.x) * asfloat(r2.w));
	r1.x = asint(min(asfloat(r1.x), 1));
	r4.xy = r4.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r4.xy = gDeferredLightShadowMap0_tex.Sample(gDeferredLightShadowMap0, r4.xy).xy;
	r2.y = asint(dot(r4.xy, asfloat(r2.yz)));
	r1.x = (asfloat(r2.y) >= asfloat(r1.x)) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r2.y = asint(sqrt(i.texcoord4.w));
	r4.xyz = r3.yzx + -(i.texcoord4.yzx);
	r5.xyz = r4.xyz * float3(1, -1, 1);
	r2.z = (0 < r4.z) ? -1 : 0;
	r2.zw = (r2.zz != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r5.w = -(abs(r5.z));
	r3.w = dot(r5.xyw, r5.xyw);
	r3.w = sqrt(r3.w);
	r4.x = abs(r5.z) + r3.w;
	r4.x = 1 / r4.x;
	r4.xy = r4.xx * r5.xy;
	r2.y = asint(asfloat(r2.y) * r3.w);
	r2.y = asint(min(asfloat(r2.y), 1));
	r4.xy = r4.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r4.xy = gDeferredLightShadowMap1_tex.Sample(gDeferredLightShadowMap1, r4.xy).xy;
	r2.z = asint(dot(r4.xy, asfloat(r2.zw)));
	r2.y = (asfloat(r2.z) >= asfloat(r2.y)) ? -1 : 0;
	r2.y = r2.y & 1065353216;
	r4.xyz = i.texcoord.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.z = asint(dot(r4.xyz, r4.xyz));
	r2.z = asint(rsqrt(asfloat(r2.z)));
	r4.xyz = asfloat(r2.zzz) * r4.xyz;
	r2.z = asint(dot(r4.xyz, asfloat(r0.xyz)));
	r2.z = asint(asfloat(r2.z) + asfloat(r2.z));
	r4.xyz = asfloat(r0.xyz) * -(asfloat(r2.zzz)) + r4.xyz;
	r5.xyz = -(r3.xyz) + i.texcoord1.xyz;
	r2.z = asint(dot(r5.xyz, r5.xyz));
	r2.w = asint(saturate(-(asfloat(r2.z)) * i.texcoord1.w + 1));
	r2.w = asint(asfloat(r2.w) * asfloat(r2.w));
	r2.w = asint(asfloat(r2.w) * asfloat(r2.w) + -0.100000001);
	r2.w = asint(max(asfloat(r2.w), 0));
	r2.w = asint(asfloat(r2.w) * 1.11111116);
	r2.z = asint(asfloat(r2.z) + 0.00000999999975);
	r2.z = asint(rsqrt(asfloat(r2.z)));
	r5.xyz = asfloat(r2.zzz) * r5.xyz;
	r2.z = asint(saturate(dot(r5.xyz, asfloat(r0.xyz))));
	r3.w = saturate(dot(r5.xyz, r4.xyz));
	r4.w = dot(r5.xyz, i.texcoord3.xyz);
	r4.w = saturate(-(r4.w) * i.texcoord2.w + i.texcoord3.w);
	r5.xyz = asfloat(r2.zzz) * i.texcoord2.xyz;
	r5.xyz = r4.www * r5.xyz;
	r5.xyz = asfloat(r2.www) * r5.xyz;
	r6 = asfloat(r1.xxx) * r5.xyz;
	r2.z = asint(r3.w + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r2.z = asint(log2(asfloat(r2.z)));
	r2.z = asint(asfloat(r0.w) * asfloat(r2.z));
	r2.z = asint(exp2(asfloat(r2.z)));
	r3.xyz = -(r3.xyz) + i.texcoord4.xyz;
	r2.w = asint(dot(r3.xyz, r3.xyz));
	r3.w = saturate(-(asfloat(r2.w)) * i.texcoord4.w + 1);
	r3.w = r3.w * r3.w;
	r3.w = r3.w * r3.w + -0.100000001;
	r3.w = max(r3.w, 0);
	r3.w = r3.w * 1.11111116;
	r2.w = asint(asfloat(r2.w) + 0.00000999999975);
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r3.xyz = asfloat(r2.www) * r3.xyz;
	r0.x = asint(saturate(dot(r3.xyz, asfloat(r0.xyz))));
	r0.y = asint(saturate(dot(r3.xyz, r4.xyz)));
	r0.z = asint(dot(r3.xyz, i.texcoord6.xyz));
	r0.z = asint(saturate(-(asfloat(r0.z)) * i.texcoord5.w + i.texcoord6.w));
	r3.xyz = asfloat(r0.xxx) * i.texcoord5.xyz;
	r3.xyz = asfloat(r0.zzz) * r3.xyz;
	r3.xyz = r3.www * r3.xyz;
	r3.xyz = asfloat(r2.yyy) * r3.xyz;
	r0.x = asint(asfloat(r0.y) + 0.00000999999975);
	r0.x = asint(log2(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w));
	r0.x = asint(exp2(asfloat(r0.x)));
	r0.xyz = asint(asfloat(r0.xxx) * r3.xyz);
	r3.xyz = r5.xyz * asfloat(r1.xxx) + r3.xyz;
	r0.xyz = asint(r6.xyz * asfloat(r2.zzz) + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r2.xxx));
	o.xyz = asfloat(r1.yzw) * r3.xyz + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
