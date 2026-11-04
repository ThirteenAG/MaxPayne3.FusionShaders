sampler2D InitPositionTexSampler : register(s6);
sampler2D InitVelocityTexSampler : register(s7);
sampler2D NoiseTexSampler : register(s5);
sampler2D ParticleCollisionSampler : register(s4);
sampler2D ParticlePosXYTexSampler : register(s0);
sampler2D ParticlePosZWTexSampler : register(s1);
float3 gBoxCentreOffset : register(c213);
float3 gBoxSize : register(c214);
row_major float4x4 gBoxTransform : register(c206);
row_major float4x4 gDepthViewProjMtx : register(c202);
float3 gGravity : register(c210);
float2 gLifeMinMax : register(c215);
float gResetParticles : register(c212);
float2 gSplashLifeMinMax : register(c216);
float gTimeStep : register(c211);
float3 gVelocityMax : register(c218);
float3 gVelocityMin : register(c217);

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
	float3 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float3 r10;
	float3 r11;
	float3 r12;
	float4 r13;
	if (gSplashLifeMinMax.y < gSplashLifeMinMax.x) {
		r0 = tex2D(InitPositionTexSampler, texcoord.xy);
		r1 = tex2D(InitVelocityTexSampler, texcoord.xy);
		r2.x = r0.w;
		r2.y = r1.w;
	} else {
		r0 = tex2D(ParticlePosXYTexSampler, texcoord.xy);
		r1 = tex2D(ParticlePosZWTexSampler, texcoord.xy);
		r2.x = r0.w;
		r2.y = r1.w;
	}
	r0.w = frac(r2.x);
	r1.w = -r0.w + r2.x;
	r3.y = r0.w * 100;
	r0.w = r2.y + -10000;
	r3.z = (r0.w >= 0) ? 1 : 0;
	r0.w = (r0.w >= 0) ? r0.w : r2.y;
	r2.x = frac(r0.w);
	r0.w = r0.w + -r2.x;
	r3.w = r2.x * 100;
	r2.xyz = float3(-1, 0, 0.01);
	r2.xyw = r2.xxy * gBoxTransform[2].xyz;
	r4.x = dot(r2.xy, r2.xy) + 0;
	r4.x = rsqrt(r4.x);
	r2.xyw = r2.xyw * r4.xxx;
	r4.zw = float2(1, 0);
	r5 = r4.zzw * gBoxTransform[0].xyz;
	r4.x = dot(r5.xy, r5.xy) + 0;
	r4.x = rsqrt(r4.x);
	r5 = r4.xxx * r5.xyz;
	r4.x = gBoxCentreOffset.x;
	r6.xyz = r4.xxx * r5.xyz + gBoxTransform[3].xyz;
	r6.xyz = gBoxCentreOffset.yyy * r2.xyw + r6.xyz;
	r6.xyz = gBoxCentreOffset.zzz * r4.wwz + r6.xyz;
	r3.x = r1.w * r2.z + -gTimeStep.x;
	r1.w = (-r3.x >= 0) ? 1 : 0;
	r2.z = (-gResetParticles.x >= 0) ? r4.w : r4.z;
	r1.w = r1.w + r2.z;
	r4.xy = r0.xy * 0.0625 + texcoord.xy;
	r7 = tex2D(NoiseTexSampler, r4.xy);
	r8 = tex2D(NoiseTexSampler, texcoord.xy);
	r9.xyz = r7.wzy + -0.5;
	r10 = r5.xyz * gBoxSize.xxx;
	r11 = r10.xyz * r9.xxx + r6.xyz;
	r12 = r2.xyw * gBoxSize.yyy;
	r9.xyw = r12.xyz * r9.yyy + r11.xyz;
	r11 = r4.wwz * gBoxSize.zzz;
	r9.xyz = r11.yyz * r9.zzz + r9.xyw;
	r13.xyz = gVelocityMin.xyz;
	r13.xyz = -r13.xyz + gVelocityMax.xyz;
	r8.yzw = r13.xyz * r8.xyz + gVelocityMin.xyz;
	r13.xy = lerp(gLifeMinMax.xx, gLifeMinMax.yy, r7.ww);
	r0.xyz = (-r1.www >= 0) ? r0.xyz : r9.xyz;
	r1.xyz = (-r1.www >= 0) ? r1.xyz : r8.yzw;
	r13.zw = r7.xx * float2(0, 1);
	r3 = (-r1.w >= 0) ? r3 : r13;
	r7.xyz = r1.xyz * gTimeStep.xxx + r0.xyz;
	r6.xyz = -r6.xyz + r7.xyz;
	r1.w = dot(r5.xy, r6.xy) + 0;
	r2.x = dot(r2.xy, r6.xy) + 0;
	r2.y = 1 / gBoxSize.x;
	r1.w = r1.w * r2.y + -0.5;
	r2.y = frac(-r1.w);
	r1.w = r1.w + r2.y;
	r2.yzw = r10.xyz * -r1.www + r7.xyz;
	r1.w = 1 / gBoxSize.y;
	r1.w = r2.x * r1.w + -0.5;
	r2.x = frac(-r1.w);
	r1.w = r1.w + r2.x;
	r2.xyz = r12.xyz * -r1.www + r2.yzw;
	r1.w = 1 / gBoxSize.z;
	r1.w = r6.z * r1.w + -0.5;
	r2.w = frac(-r1.w);
	r1.w = r1.w + r2.w;
	r2.xyz = r11.xyz * -r1.www + r2.xyz;
	r4.x = gTimeStep.x;
	r5 = gGravity.xyz * r4.xxx + r1.xyz;
	r6.xyz = r2.yyy * gDepthViewProjMtx[1].xyz;
	r6.xyz = r2.xxx * gDepthViewProjMtx[0].xyz + r6.xyz;
	r6.xyz = r2.zzz * gDepthViewProjMtx[2].xyz + r6.xyz;
	r6.xyz = r6.xyz + gDepthViewProjMtx[3].xyz;
	r6.w = -r6.y + 1;
	r7 = tex2D(ParticleCollisionSampler, r6.xw);
	r1.w = -r7.x + 1;
	if (r1.w >= r6.z) {
		r1.w = r1.w + -gDepthViewProjMtx[3].z;
		r4.x = 1 / gDepthViewProjMtx[2].z;
		r2.w = r1.w * r4.x;
		r6.x = lerp(gSplashLifeMinMax.x, gSplashLifeMinMax.y, r8.x);
		r6.yz = gSplashLifeMinMax.yy * r4.zw + r4.wz;
	} else {
		r6.xyz = r3.xyz;
		r2.w = r2.z;
	}
	o.color.xyz = (-r3.zzz >= 0) ? r2.xyw : r0.xyz;
	o.color1.xyz = (-r3.zzz >= 0) ? r5.xyz : r1.xyz;
	r0.xyz = (-r3.zzz >= 0) ? r6.xyz : r3.xyz;
	r0.xz = r0.xz * float2(100, 10000);
	r1.x = frac(r0.x);
	r0.x = r0.x + -r1.x;
	o.color.w = r0.y * 0.01 + r0.x;
	r0.x = frac(r0.w);
	r0.x = -r0.x + r0.w;
	r0.x = r0.x + r0.z;
	o.color1.w = r3.w * 0.01 + r0.x;

	return o;
}
