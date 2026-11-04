sampler2D BackBufferSampler : register(s0);
float4 globalScreenSize : register(c41);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.x = 0.5;
	r0.yz = r0.xx * globalScreenSize.zw;
	r1.xy = globalScreenSize.zw * -r0.xx + texcoord.xy;
	r2.xy = globalScreenSize.zw * r0.xx + texcoord.xy;
	r1.z = 0;
	r3 = tex2Dlod(BackBufferSampler, r1.xyzz);
	r1.w = r2.y;
	r4 = tex2Dlod(BackBufferSampler, r1.xwzz);
	r2.zw = r1.yz;
	r1 = tex2Dlod(BackBufferSampler, r2.xzww);
	r2 = tex2Dlod(BackBufferSampler, r2.xyww);
	r5 = float4(1, 1, 0, 0) * texcoord.xyxx;
	r5 = tex2Dlod(BackBufferSampler, r5);
	r0.x = max(r3.w, r4.w);
	r0.w = r1.w + 0.0026041667;
	r1.x = min(r4.w, r3.w);
	r1.y = max(r0.w, r2.w);
	r1.z = min(r2.w, r0.w);
	r2.x = max(r1.y, r0.x);
	r0.x = min(r1.x, r1.z);
	r1.x = r2.x * 0.125;
	r1.y = min(r5.w, r0.x);
	r1.z = max(r2.x, r5.w);
	r1.y = -r1.y + r1.z;
	r2.y = min(-r1.x, -0.05);
	if (r1.y < -r2.y) {
		o = r5;
	} else {
		r1.xy = globalScreenSize.zw + globalScreenSize.zw;
		r0.w = -r0.w + r4.w;
		r1.z = -r3.w + r2.w;
		r3.x = r0.w + r1.z;
		r3.y = r0.w + -r1.z;
		r0.w = dot(r3.xy, r3.xy) + 0;
		r0.w = rsqrt(r0.w);
		r1.zw = r0.ww * r3.xy;
		r3.xy = r1.zw * -r0.yz + texcoord.xy;
		r3.zw = 0;
		r3 = tex2Dlod(BackBufferSampler, r3);
		r4.xy = r1.zw * r0.yz + texcoord.xy;
		r4.zw = 0;
		r4 = tex2Dlod(BackBufferSampler, r4);
		r0.y = min(abs(r1.w), abs(r1.z));
		r0.y = r0.y * 8;
		r0.y = 1 / r0.y;
		r0.yz = r0.yy * r1.zw;
		r1.zw = max(r0.yz, -2);
		r0.yz = min(r1.zw, 2);
		r5.xy = r0.yz * -r1.xy + texcoord.xy;
		r5.zw = 0;
		r5 = tex2Dlod(BackBufferSampler, r5);
		r1.xy = r0.yz * r1.xy + texcoord.xy;
		r1.zw = 0;
		r1 = tex2Dlod(BackBufferSampler, r1);
		r3 = r3 + r4;
		r1 = r1 + r5;
		r4 = r3 * 0.25;
		r1 = r1 * 0.25 + r4;
		r0.x = -r0.x + r1.w;
		r0.y = -r1.w + r2.x;
		r0.xy = (r0.xy >= 0) ? 0 : 1;
		r0.x = r0.y + r0.x;
		r0.yzw = r3.xyz * 0.5;
		o.xyz = (-r0.xxx >= 0) ? r1.xyz : r0.yzw;
		o.w = r1.w;
	}

	return o;
}
