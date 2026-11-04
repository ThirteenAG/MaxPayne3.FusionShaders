float4 Acceleration_Delta : register(c206);
float4 EmitterParamLifeAndSpeed : register(c209);
float3 EmitterParamPos : register(c207);
float3 EmitterParamPosRange : register(c208);
float EmitterParamProbablityPhase2 : register(c210);
row_major float4x4 EmitterTransform : register(c202);
float3 EmitterVelocityBoxPos : register(c211);
float4 EmitterVelocityBoxRange : register(c212);
sampler2D InitPositionTexSampler : register(s6);
sampler2D InitVelocityTexSampler : register(s7);
sampler2D NoiseTexSampler : register(s5);
sampler2D ParticleCollisionSampler : register(s4);
sampler2D ParticlePosXYTexSampler : register(s0);
sampler2D ParticlePosZWTexSampler : register(s1);
float2 gCollisionLifeModifier : register(c215);
float3 gCollisionPositionModifier : register(c216);
float3 gCollisionVelocityModifier : register(c214);
row_major float4x4 gDepthViewProjMtx : register(c217);
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
	float4 r6;
	float3 r7;
	r0.xyz = float3(-1, 1, 0);
	r0.xw = r0.xx + gGustSpacing.xy;
	r0.w = (-abs(r0.w) >= 0) ? 1 : 0;
	r0.x = (-abs(r0.x) >= 0) ? r0.w : 0;
	if (r0.x != -r0.x) {
		r1 = tex2D(InitPositionTexSampler, texcoord.xy);
		r2 = tex2D(InitVelocityTexSampler, texcoord.xy);
		r0.x = r1.w;
	} else {
		r1 = tex2D(ParticlePosXYTexSampler, texcoord.xy);
		r2 = tex2D(ParticlePosZWTexSampler, texcoord.xy);
		r0.x = r1.w;
	}
	r3.x = r0.x + -Acceleration_Delta.w;
	r0.xw = r1.xy * 0.0625 + texcoord.xy;
	r4 = tex2D(NoiseTexSampler, r0.xw);
	r5 = tex2D(NoiseTexSampler, texcoord.xy);
	r5.yzw = r5.xyz * 2 + -1;
	r6.xyz = EmitterVelocityBoxRange.xyz;
	r6.xyz = r6.xyz * r5.yzw + EmitterVelocityBoxPos.xyz;
	r4.xyz = r4.wzy * 2 + -1;
	r7 = EmitterTransform[3].xyz;
	r4.xyz = EmitterParamPosRange.xyz * r4.xyz + r7.xyz;
	r5.y = EmitterParamPos.y;
	r5.yzw = r5.yyy * -EmitterTransform[2].xyz;
	r4.xyz = r5.yzw * float3(1, 1, 0) + r4.xyz;
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
	r0.xyz = r6.xyz * -0.2 + r4.xyz;
	r4.x = EmitterParamLifeAndSpeed.w * r4.w + EmitterParamLifeAndSpeed.z;
	r0.w = r5.x + -EmitterParamProbablityPhase2.x;
	r4.y = (r0.w >= 0) ? 0 : 1;
	r6.w = 0;
	r2 = (-r3.x >= 0) ? r6 : r2;
	r0.xyz = (-r3.xxx >= 0) ? r0.xyz : r1.xyz;
	r3.y = 0;
	r1.xw = (-r3.xx >= 0) ? r4.yx : r3.yx;
	r0.xyz = r2.xyz * Acceleration_Delta.www + r0.xyz;
	r3.xyz = r0.yyy * gDepthViewProjMtx[1].xyz;
	r3.xyz = r0.xxx * gDepthViewProjMtx[0].xyz + r3.xyz;
	r3.xyz = r0.zzz * gDepthViewProjMtx[2].xyz + r3.xyz;
	r3.xyz = r3.xyz + gDepthViewProjMtx[3].xyz;
	r3.w = -r3.y + 1;
	r4 = tex2D(ParticleCollisionSampler, r3.xw);
	r3.x = -r4.x + 1;
	r3.y = -r3.z + r3.x;
	r3.y = (r3.y >= 0) ? 1 : 0;
	r3.y = r1.x + r3.y;
	r3.x = r3.x + -gDepthViewProjMtx[3].z;
	r3.z = 1 / gDepthViewProjMtx[2].z;
	r0.w = r3.z * r3.x;
	r4.xyz = r0.xyw + gCollisionPositionModifier.xyz;
	r0.w = r1.w * gCollisionLifeModifier.x + gCollisionLifeModifier.y;
	r4.w = (-abs(r2.w) >= 0) ? r0.w : r1.w;
	r5.w = r2.w + 1;
	r0.w = (-abs(r2.w) >= 0) ? -1 : -0;
	r0.w = (-r3.y >= 0) ? -0 : r0.w;
	r1.xyz = r0.xyz;
	o.color = (r0.w >= 0) ? r1 : r4;
	r5.xyz = 0;
	r0 = (r0.w >= 0) ? r2 : r5;
	r1.w = 0.9995;
	r1.xyz = (-r0.www >= 0) ? r1.www : gCollisionVelocityModifier.xyz;
	r0.xyz = Acceleration_Delta.xyz * Acceleration_Delta.www + r0.xyz;
	o.color1.xyz = r1.xyz * r0.xyz;
	o.color1.w = r0.w;

	return o;
}
