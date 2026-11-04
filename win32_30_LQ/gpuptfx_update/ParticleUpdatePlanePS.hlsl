float4 Acceleration_Delta : register(c206);
float4 EmitterParamLifeAndSpeed : register(c209);
float3 EmitterParamPos : register(c207);
float3 EmitterParamPosRange : register(c208);
row_major float4x4 EmitterTransform : register(c202);
float3 EmitterVelocityBoxPos : register(c211);
float4 EmitterVelocityBoxRange : register(c212);
sampler2D InitPositionTexSampler : register(s6);
sampler2D InitVelocityTexSampler : register(s7);
sampler2D NoiseTexSampler : register(s5);
sampler2D ParticlePosXYTexSampler : register(s0);
sampler2D ParticlePosZWTexSampler : register(s1);
float3 gCollisionVelocityModifier : register(c214);
float4 gDispersalSettings : register(c221);
float2 gGustSpacing : register(c222);

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0.xyz = float3(-1, 1, 0);
	r0.xw = r0.xx + gGustSpacing.xy;
	r0.w = (-abs(r0.w) >= 0) ? 1 : 0;
	r0.x = (-abs(r0.x) >= 0) ? r0.w : 0;
	if (r0.x != -r0.x) {
		r1 = tex2D(InitPositionTexSampler, texcoord.xy);
		r2 = tex2D(InitVelocityTexSampler, texcoord.xy);
		r0.x = r1.w;
		r3.y = r2.w;
	} else {
		r1 = tex2D(ParticlePosXYTexSampler, texcoord.xy);
		r2 = tex2D(ParticlePosZWTexSampler, texcoord.xy);
		r0.x = r1.w;
		r3.y = r2.w;
	}
	r3.x = r0.x + -Acceleration_Delta.w;
	r0.xw = r1.xy * 0.0625 + texcoord.xy;
	r4 = tex2D(NoiseTexSampler, r0.xw);
	r5 = tex2D(NoiseTexSampler, texcoord.xy);
	r5.xyz = r5.xyz * 2 + -1;
	r6 = EmitterVelocityBoxRange.xyz;
	r5.xyz = r6.xyz * r5.xyz + EmitterVelocityBoxPos.xyz;
	r4.xyz = r4.wzy * 2 + -1;
	r6 = EmitterTransform[3].xyz;
	r4.xyz = EmitterParamPosRange.xyz * r4.xyz + r6.xyz;
	r6.y = EmitterParamPos.y;
	r6 = r6.yyy * -EmitterTransform[2].xyz;
	r4.xyz = r6.xyz * float3(1, 1, 0) + r4.xyz;
	r0.xzw = EmitterParamPos.zzz * r0.zzy + r4.xyz;
	r3.zw = r0.xz + -EmitterTransform[3].xy;
	r1.w = dot(r3.zw, r3.zw) + 0;
	r1.w = rsqrt(r1.w);
	r1.w = 1 / r1.w;
	r1.w = r1.w + -gDispersalSettings.x;
	r0.y = r1.w * gDispersalSettings.y + r0.y;
	r0.y = (r1.w >= 0) ? r0.y : 1;
	r4.xy = lerp(EmitterTransform[3].xy, r0.xz, r0.yy);
	r4.z = r0.w;
	r0.xyz = r5.xyz * -0.2 + r4.xyz;
	r4.x = EmitterParamLifeAndSpeed.w * r4.w + EmitterParamLifeAndSpeed.z;
	r0.xyz = (-r3.xxx >= 0) ? r0.xyz : r1.xyz;
	r1.xyz = (-r3.xxx >= 0) ? r5.xyz : r2.xyz;
	r4.y = 0;
	r2.xy = (-r3.xx >= 0) ? r4.xy : r3.xy;
	o.color.xyz = r1.xyz * Acceleration_Delta.www + r0.xyz;
	r0.w = 0.9995;
	r0.xyz = (-r2.yyy >= 0) ? r0.www : gCollisionVelocityModifier.xyz;
	r1.xyz = Acceleration_Delta.xyz * Acceleration_Delta.www + r1.xyz;
	o.color1.xyz = r0.xyz * r1.xyz;
	o.color.w = r2.x;
	o.color1.w = r2.y;

	return o;
}
