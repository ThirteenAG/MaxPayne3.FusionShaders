sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
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
sampler2D materialIdSampler : register(s9);

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
	float4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r2 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r3 = tex2D(GBufferTextureSampler0, r0.xy);
	r4 = tex2D(GBufferTextureSampler2, r0.xy);
	r5 = tex2D(GBufferTextureSampler1, r0.xy);
	r0 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * 16;
	r1.yzw = r3.xyz * r3.xyz;
	r0.w = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.w = r0.w * i.texcoord.w;
	r0.w = 1 / r0.w;
	r2.xyz = i.texcoord.xyz * -r0.www + gViewInverse[3].xyz;
	r3 = tex2D(materialIdSampler, r2.ww);
	r1.x = r3.w * -132 + 196;
	r2.w = r4.y * r4.y;
	r3.xyz = r5.xyz * 2 + -1;
	r5.xyz = normalize(r3.xyz);
	r3.xyz = r2.xyz + -i.texcoord2.xyz;
	r6 = gDeferredLightDirection.xyz;
	r4.yzw = -r6.zxy * gDeferredLightTangent.yzx;
	r4.yzw = -r6.yzx * gDeferredLightTangent.zxy + -r4.yzw;
	r6.x = dot(r4.yzw, r3.xyz);
	r6.y = dot(gDeferredLightTangent.xyz, r3.xyz);
	r3.w = dot(-gDeferredLightDirection.xyz, r3.xyz);
	r7.x = 2;
	if (gDeferredLightType.x == r7.x) {
		r4.y = abs(gDeferredLightConeOffset.x);
		r4.y = r4.y + 60;
		r4.y = 1 / r4.y;
		r4.y = r4.y * gDeferredLightConeAngle.x;
		r4.y = r4.y * 120;
		r4.y = r4.y * r4.y;
		r4.y = r3.w * r4.y;
		r4.y = 1 / r4.y;
		r4.yz = -r4.yy * r6.xy;
		r7.xy = r4.yz * 0.5 + 0.5;
		r7.zw = 0;
		r7 = tex2Dlod(gDeferredLightSampler, r7);
	} else {
		r3.x = dot(r3.xyz, r3.xyz);
		r3.x = rsqrt(r3.x);
		r3.y = 1 / r3.x;
		r3.x = r3.w * -r3.x + 1;
		r3.x = r3.x * r3.y;
		r3.x = 1 / r3.x;
		r3.xy = r3.xx * r6.xy;
		r3.xy = r3.xy * 0.5 + 0.5;
		r3.zw = 0;
		r7 = tex2Dlod(gDeferredLightSampler, r3);
	}
	r3.xyz = i.texcoord.xyz * -r0.www + 1E-05;
	r6 = normalize(r3.xyz);
	r2.xyz = -r2.xyz + i.texcoord2.xyz;
	r0.w = dot(r2.xyz, r2.xyz);
	r2.xyz = r2.xyz + 1E-05;
	r3.xyz = normalize(r2.xyz);
	r0.w = saturate(r0.w * -i.texcoord1.y + 1);
	r0.w = r0.w + 1E-05;
	r2.x = pow(r0.w, 4.00001);
	r0.w = r2.x + -0.1;
	r2.x = r0.w * 1.1111112;
	r2.xyz = r2.xxx * i.texcoord4.xyz;
	r3.w = dot(r3.xyz, i.texcoord3.xyz);
	r3.w = saturate(r3.w * i.texcoord1.w + i.texcoord1.z);
	r2.xyz = r2.xyz * r3.www;
	r2.xyz = (r0.www >= 0) ? r2.xyz : 0;
	r0.w = dot(r6.xyz, r5.xyz);
	r0.w = r0.w + r0.w;
	r4.yzw = r5.xyz * -r0.www + r6.xyz;
	r0.w = saturate(dot(r3.xyz, r4.yzw));
	r0.w = r0.w + 1E-05;
	r1.x = r2.w * r1.x + 1E-05;
	r2.w = pow(r0.w, r1.x);
	r0.w = saturate(dot(r3.xyz, r5.xyz));
	r1.x = saturate(r0.w * 2 + -0.5);
	r1.x = r1.x * r2.w;
	r3.xyz = r1.xxx * r2.xyz;
	r2.xyz = r0.www * r2.xyz;
	r1.xyz = r1.yzw * r7.xyz;
	r0.w = dot(r2.xyz, 0.33333334);
	r0.xyz = r0.www * r0.xyz;
	r0.xyz = r3.xyz * r4.xxx + r0.xyz;
	o.xyz = r1.xyz * r2.xyz + r0.xyz;
	o.w = 1;

	return o;
}
