sampler2D SmartBlitSampler : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.zw = 0;
	r1.xyz = float3(-16384, 16384, 0);
	for (int i0 = 0; i0 < 8; i0++) {
		r2.x = r1.z;
		r2.zw = r1.xy;
		r1.w = 0;
		for (int i1 = 0; i1 < 8; i1++) {
			r2.y = r1.w;
			r0.xy = r2.xy * 0.001953125 + texcoord.xy;
			r3 = tex2Dlod(SmartBlitSampler, r0);
			r0.x = max(r3.y, r2.z);
			r0.y = min(r2.w, r3.y);
			r1.w = r1.w + 1;
			r2.zw = r0.xy;
		}
		r1.xy = r2.zw;
		r1.z = r1.z + 1;
	}
	r0.x = -r1.y + r1.x;
	o.z = (-abs(r0.x) >= 0) ? 1 : 0;
	o.w = 1;
	o.xy = r1.xy;

	return o;
}
