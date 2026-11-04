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
sampler2D ParticlePosXYTexSampler : register(s0);
sampler2D ParticlePosZWTexSampler : register(s1);
float2 gCollisionLifeModifier : register(c215);
float3 gCollisionVelocityModifier : register(c214);
float4 gDispersalSettings : register(c221);
float2 gGustSpacing : register(c222);
float4 gHitPlane : register(c213);

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
	float2 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.xy = float2(-1, 1);
	r0.xz = r0.xx + gGustSpacing.xy;
	r0.z = (-abs(r0.z) >= 0) ? 1 : 0;
	r0.x = (-abs(r0.x) >= 0) ? r0.z : 0;
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
	r0.xz = r1.xz * 0.0625 + texcoord.xy;
	r4 = tex2D(NoiseTexSampler, r0.xz);
	r5 = tex2D(NoiseTexSampler, texcoord.xy);
	r0.xzw = r5.xyz * 2 + -1;
	r6.xyz = EmitterVelocityBoxRange.xyz;
	r6.xyz = r6.xyz * r0.xzw + EmitterVelocityBoxPos.xyz;
	r0.xzw = r4.wzy * 2 + -1;
	r4.xyz = EmitterParamPosRange.xyz;
	r0.xzw = r4.xyz * r0.xzw + EmitterParamPos.xyz;
	r4.xyz = r0.zzz * EmitterTransform[1].xyz;
	r4.xyz = r0.xxx * EmitterTransform[0].xyz + r4.xyz;
	r0.xzw = r0.www * EmitterTransform[2].xyz + r4.xyz;
	r4.y = r0.z + EmitterTransform[3].y;
	r0.z = dot(r0.xw, r0.xw) + 0;
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.z = r0.z + -gDispersalSettings.x;
	r0.y = r0.z * gDispersalSettings.y + r0.y;
	r0.y = (r0.z >= 0) ? r0.y : 1;
	r4.xz = r0.xw * r0.yy + EmitterTransform[3].xz;
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
	r0.w = 1;
	r0.w = dot(r0, gHitPlane);
	r3.x = (r0.w >= 0) ? 0 : 1;
	r3.x = r1.x + r3.x;
	r4.xyz = gHitPlane.xyz * -r0.www + r0.xyz;
	r5.xyz = r2.xyz * gCollisionVelocityModifier.xyz;
	r0.w = r1.w * gCollisionLifeModifier.x + gCollisionLifeModifier.y;
	r4.w = (-abs(r2.w) >= 0) ? r0.w : r1.w;
	r5.w = r2.w + 1;
	r1.xyz = r0.xyz;
	o.color = (-r3.x >= 0) ? r1 : r4;
	r0 = (-r3.x >= 0) ? r2 : r5;
	r1.w = 0.9995;
	r1.xyz = (-r0.www >= 0) ? r1.www : gCollisionVelocityModifier.xyz;
	r0.xyz = Acceleration_Delta.xyz * Acceleration_Delta.www + r0.xyz;
	o.color1.xyz = r1.xyz * r0.xyz;
	o.color1.w = r0.w;

	return o;
}
