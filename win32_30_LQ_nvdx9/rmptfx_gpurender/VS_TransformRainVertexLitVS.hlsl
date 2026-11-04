sampler2D PositionTexSampler : register(s1);
sampler2D VelocityTexSampler : register(s3);
float gAmbientAmount : register(c101);
float4 gAmbientOcclusionEffect : register(c63);
float4 gColorTint : register(c95);
float4 gColorTintPhase2 : register(c96);
float gDiffuse : register(c100);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gRadius : register(c92);
float4 gTextureAnimation : register(c94);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	float3 r6;
	r0 = tex2Dlod(PositionTexSampler, i.position);
	r1 = tex2Dlod(VelocityTexSampler, i.position);
	if (-abs(r1.w) >= abs(r1.w)) {
		r2.x = gRadius.x;
		r1.w = r2.x * 0.125;
		r2.xyz = r2.xxx * float3(0, 0, 0.5) + r0.xyz;
		r3.xy = float2(-0.5, -0.7) + i.texcoord.xy;
		r4 = normalize(r1.xyz);
		r1.xyz = -r2.xyz + gViewInverse[3].xyz;
		r5.xyz = r1.yzx * r4.zxy;
		r5.xyz = r4.yzx * r1.zxy + -r5.xyz;
		r6 = normalize(r5.xyz);
		r5.xyz = r1.www * r6.xyz;
		r4 = r4.xyz * gRadius.xxx;
		r3.yzw = r3.yyy * r4.xyz;
		r3.xyz = r3.xxx * r5.xyz + r3.yzw;
		r4 = normalize(r1.xyz);
		r1.xyz = r2.xyz + r3.xyz;
		r2 = r1.y * gWorldViewProj[1];
		r2 = r1.x * gWorldViewProj[0] + r2;
		r1 = r1.z * gWorldViewProj[2] + r2;
		o.position = r1 + gWorldViewProj[3];
		r1.w = gColorTint.w;
		r1.x = r1.w + 0.05;
		r1.yzw = gColorTint.xyz;
		r2.x = i.texcoord.x;
	} else {
		r2.z = gRadius.z;
		r3 = r2.z * float4(0, 0, 0.5, 0) + r0;
		r2.zw = -0.5 + i.texcoord.xy;
		r5.xyz = normalize(gViewInverse[0].xyz);
		r5.xyz = r5.xyz * gRadius.zzz;
		r6 = normalize(-gViewInverse[1].xyz);
		r6 = r6.xyz * gRadius.zzz;
		r6 = r2.www * r6.xyz;
		r5.xyz = r2.zzz * r5.xyz + r6.xyz;
		r4 = normalize(r5.xyz);
		r3.xyz = r3.xyz + r5.xyz;
		r5 = r3.y * gWorldViewProj[1];
		r5 = r3.x * gWorldViewProj[0] + r5;
		r5 = r3.z * gWorldViewProj[2] + r5;
		o.position = r5 + gWorldViewProj[3];
		r0.w = gColorTintPhase2.w;
		r1.x = r0.w + 0.1;
		r0.w = r3.w * gTextureAnimation.x + -gTextureAnimation.y;
		r2.z = frac(r0.w);
		r2.w = r0.w + -r2.z;
		r0.w = (r0.w < -r0.w) ? 1 : 0;
		r2.z = (-r2.z < r2.z) ? 1 : 0;
		r0.w = r0.w * r2.z + r2.w;
		r0.w = saturate(r0.w * gTextureAnimation.z);
		r0.w = gTextureAnimation.z * i.texcoord.x + r0.w;
		r2.x = r0.w + -10;
		r1.yzw = gColorTintPhase2.xyz;
	}
	r0.w = dot(r4.xyz, gWorldView[2].xyz);
	r0.w = saturate(r0.w * -0.5 + 0.5);
	r3.xyz = gLightAmbient0.xyz;
	r3.xyz = -r3.xyz + gLightAmbient1.xyz;
	r3.xyz = r0.www * r3.xyz + gLightAmbient0.xyz;
	r3.xyz = r3.xyz * gAmbientOcclusionEffect.yyy;
	r3.xyz = r3.xyz * gAmbientAmount.xxx;
	r0.w = 1 / gAmbientOcclusionEffect.y;
	r3.xyz = r0.www * r3.xyz;
	r3.xyz = r3.xyz * gDiffuse.xxx;
	o.color.xyz = r1.yzw * r3.xyz;
	r0.xyz = -r0.xyz + gViewInverse[3].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * 0.6666667;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * r1.x;
	r2.y = i.texcoord.y;
	o.texcoord = r2.xy;

	return o;
}
