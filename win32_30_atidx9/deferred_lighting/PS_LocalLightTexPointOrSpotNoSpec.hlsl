sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float gDeferredLightConeAngle : register(c211);
float gDeferredLightConeOffset : register(c212);
float3 gDeferredLightDirection : register(c204);
sampler2D gDeferredLightSampler : register(s0);
sampler2D gDeferredLightSampler0P : register(s3);
float3 gDeferredLightTangent : register(c205);
float gDeferredLightType : register(c202);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float2 vpos : VPOS;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	float4 r6;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r2 = tex2D(GBufferTextureSampler0, r0.xy);
	r3 = tex2D(GBufferTextureSampler1, r0.xy);
	r0 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * 16;
	r1.yzw = r2.xyz * r2.xyz;
	r0.w = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.w = r0.w * i.texcoord.w;
	r0.w = 1 / r0.w;
	r2.xyz = i.texcoord.xyz * -r0.www + gViewInverse[3].xyz;
	r3.xyz = r3.xyz * 2 + -1;
	r4 = normalize(r3.xyz);
	r3.xyz = r2.xyz + -i.texcoord2.xyz;
	r5.xyz = gDeferredLightDirection.xyz;
	r6.xyz = -r5.zxy * gDeferredLightTangent.yzx;
	r5.xyz = -r5.yzx * gDeferredLightTangent.zxy + -r6.xyz;
	r5.x = dot(r5.xyz, r3.xyz);
	r5.y = dot(gDeferredLightTangent.xyz, r3.xyz);
	r0.w = dot(-gDeferredLightDirection.xyz, r3.xyz);
	r5.z = 2;
	if (gDeferredLightType.x == r5.z) {
		r1.x = abs(gDeferredLightConeOffset.x);
		r1.x = r1.x + 60;
		r1.x = 1 / r1.x;
		r1.x = r1.x * gDeferredLightConeAngle.x;
		r1.x = r1.x * 120;
		r1.x = r1.x * r1.x;
		r1.x = r0.w * r1.x;
		r1.x = 1 / r1.x;
		r5.zw = -r1.xx * r5.xy;
		r6.xy = r5.zw * 0.5 + 0.5;
		r6.zw = 0;
		r6 = tex2Dlod(gDeferredLightSampler, r6);
	} else {
		r1.x = dot(r3.xyz, r3.xyz);
		r1.x = rsqrt(r1.x);
		r2.w = 1 / r1.x;
		r0.w = r0.w * -r1.x + 1;
		r0.w = r0.w * r2.w;
		r0.w = 1 / r0.w;
		r3.xy = r0.ww * r5.xy;
		r3.xy = r3.xy * 0.5 + 0.5;
		r3.zw = 0;
		r6 = tex2Dlod(gDeferredLightSampler, r3);
	}
	r2.xyz = -r2.xyz + i.texcoord2.xyz;
	r0.w = dot(r2.xyz, r2.xyz);
	r2.xyz = r2.xyz + 1E-05;
	r3.xyz = normalize(r2.xyz);
	r0.w = saturate(r0.w * -i.texcoord1.y + 1);
	r0.w = r0.w + 1E-05;
	r1.x = pow(r0.w, 2.00001);
	r0.w = r1.x + -0.33333334;
	r1.x = r0.w * 1.5;
	r2.x = dot(r3.xyz, i.texcoord3.xyz);
	r2.x = saturate(r2.x * i.texcoord1.w + i.texcoord1.z);
	r1.x = r1.x * r2.x;
	r2.x = dot(r4.xyz, r3.xyz);
	r2.x = r2.x + -0.2;
	r2.x = saturate(r2.x * 1.25);
	r1.x = r1.x * r2.x;
	r2.xyz = r1.xxx * i.texcoord4.xyz;
	r2.xyz = (r0.www >= 0) ? r2.xyz : 0;
	r1.xyz = r1.yzw * r6.xyz;
	r0.w = dot(r2.xyz, 0.33333334);
	r0.xyz = r0.www * r0.xyz;
	o.xyz = r1.xyz * r2.xyz + r0.xyz;
	o.w = 1;

	return o;
}
