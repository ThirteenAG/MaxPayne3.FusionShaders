sampler2D blitSampler : register(s2);

float4 main() : COLOR
{
	float4 o;

	float4 r1;
	float4 r2;
	float4 r3;
	float4 r0;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 r12;
	float4 r13;
	float4 r14;
	float4 r15;
	r1.yw = float2(0.1875, 0.3125);
	r2.yw = float2(0.4375, 0.5625);
	r3.yw = float2(0.6875, 0.8125);
	r0.yw = float2(0.0625, 0.9375);
	r4 = 0;
	r5.x = 0;
	for (int i0 = 0; i0 < 8; i0++) {
		r0.xz = r5.xx * 0.125 + 0.0625;
		r6 = tex2D(blitSampler, r0.xy);
		r1.xz = r5.xx * 0.125 + 0.0625;
		r7 = tex2D(blitSampler, r1.xy);
		r8 = tex2D(blitSampler, r1.zw);
		r2.xz = r5.xx * 0.125 + 0.0625;
		r9 = tex2D(blitSampler, r2.xy);
		r10 = tex2D(blitSampler, r2.zw);
		r3.xz = r5.xx * 0.125 + 0.0625;
		r11 = tex2D(blitSampler, r3.xy);
		r12 = tex2D(blitSampler, r3.zw);
		r13 = tex2D(blitSampler, r0.zw);
		r14.x = dot(r6.xyz, 1);
		r14.y = dot(r7.xyz, 1);
		r14.z = dot(r8.xyz, 1);
		r14.w = dot(r9.xyz, 1);
		r15.x = dot(r10.xyz, 1);
		r15.y = dot(r11.xyz, 1);
		r15.z = dot(r12.xyz, 1);
		r15.w = dot(r13.xyz, 1);
		r14 = r14 + -0.5;
		r14 = (r14 >= 0) ? 1 : 0;
		r15 = r15 + -0.5;
		r15 = (r15 >= 0) ? 1 : 0;
		r5.yzw = r6.xyz * r14.xxx + r4.xyz;
		r5.yzw = r7.xyz * r14.yyy + r5.yzw;
		r5.yzw = r8.xyz * r14.zzz + r5.yzw;
		r5.yzw = r9.xyz * r14.www + r5.yzw;
		r5.yzw = r10.xyz * r15.xxx + r5.yzw;
		r5.yzw = r11.xyz * r15.yyy + r5.yzw;
		r5.yzw = r12.xyz * r15.zzz + r5.yzw;
		r4.xyz = r13.xyz * r15.www + r5.yzw;
		r0.x = dot(r14, 1);
		r0.z = dot(r15, 1);
		r0.x = r0.z + r0.x;
		r4.w = r0.x + r4.w;
		r5.x = r5.x + 1;
	}
	r0.x = 1 / r4.w;
	o.xyz = r0.xxx * r4.xyz;
	o.w = 1;

	return o;
}
