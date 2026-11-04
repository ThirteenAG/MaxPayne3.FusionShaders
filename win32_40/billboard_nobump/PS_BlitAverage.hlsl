SamplerState blitSampler : register(s2);
Texture2D blitSampler_tex : register(t2);

float4 main(float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	int4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 r12;
	float4 r13;
	int4 r14;
	int4 r15;
	r0.yw = float2(0.0625, 0.1875);
	r1.yw = float2(0.3125, 0.4375);
	r2.yw = float2(0.5625, 0.6875);
	r3.yw = float2(0.8125, 0.9375);
	r4 = float4(0, 0, 0, 0);
	r5.x = 0;
	while (true) {
		r5.y = (r5.x >= 8) ? -1 : 0;
		if (r5.y != 0) break;
		r5.y = asint((float)r5.x);
		r0.xz = asfloat(r5.yy) * float2(0.125, 0.125) + float2(0.0625, 0.0625);
		r6 = blitSampler_tex.Sample(blitSampler, r0.xy);
		r7 = blitSampler_tex.Sample(blitSampler, r0.zw);
		r1.xz = asfloat(r5.yy) * float2(0.125, 0.125) + float2(0.0625, 0.0625);
		r8 = blitSampler_tex.Sample(blitSampler, r1.xy);
		r9 = blitSampler_tex.Sample(blitSampler, r1.zw);
		r2.xz = asfloat(r5.yy) * float2(0.125, 0.125) + float2(0.0625, 0.0625);
		r10 = blitSampler_tex.Sample(blitSampler, r2.xy);
		r11 = blitSampler_tex.Sample(blitSampler, r2.zw);
		r3.xz = asfloat(r5.yy) * float2(0.125, 0.125) + float2(0.0625, 0.0625);
		r12 = blitSampler_tex.Sample(blitSampler, r3.xy);
		r13 = blitSampler_tex.Sample(blitSampler, r3.zw);
		r14.x = asint(dot(r6.xyz, float3(1, 1, 1)));
		r14.y = asint(dot(r7.xyz, float3(1, 1, 1)));
		r14.z = asint(dot(r8.xyz, float3(1, 1, 1)));
		r14.w = asint(dot(r9.xyz, float3(1, 1, 1)));
		r15.x = asint(dot(r10.xyz, float3(1, 1, 1)));
		r15.y = asint(dot(r11.xyz, float3(1, 1, 1)));
		r15.z = asint(dot(r12.xyz, float3(1, 1, 1)));
		r15.w = asint(dot(r13.xyz, float3(1, 1, 1)));
		r14 = (asfloat(r14) >= float4(0.5, 0.5, 0.5, 0.5)) ? -1 : 0;
		r14 = r14 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r15 = (asfloat(r15) >= float4(0.5, 0.5, 0.5, 0.5)) ? -1 : 0;
		r15 = r15 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r5.yzw = asint(r6.xyz * asfloat(r14.xxx) + r4.xyz);
		r5.yzw = asint(r7.xyz * asfloat(r14.yyy) + asfloat(r5.yzw));
		r5.yzw = asint(r8.xyz * asfloat(r14.zzz) + asfloat(r5.yzw));
		r5.yzw = asint(r9.xyz * asfloat(r14.www) + asfloat(r5.yzw));
		r5.yzw = asint(r10.xyz * asfloat(r15.xxx) + asfloat(r5.yzw));
		r5.yzw = asint(r11.xyz * asfloat(r15.yyy) + asfloat(r5.yzw));
		r5.yzw = asint(r12.xyz * asfloat(r15.zzz) + asfloat(r5.yzw));
		r4.xyz = r13.xyz * asfloat(r15.www) + asfloat(r5.yzw);
		r0.x = dot(asfloat(r14), float4(1, 1, 1, 1));
		r0.z = dot(asfloat(r15), float4(1, 1, 1, 1));
		r0.x = r0.z + r0.x;
		r4.w = r0.x + r4.w;
		r5.x = r5.x + 1;
	}
	o.xyz = r4.xyz / r4.www;
	o.w = 1;

	return o;
}
