sampler2D HemiCubeSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xy = -0.5 + texcoord.xy;
	r0.zw = r0.xy * 2 + 1E-05;
	r0.xy = r0.xy + r0.xy;
	r1.x = dot(r0.zw, r0.zw) + 0;
	r1.x = rsqrt(r1.x);
	r1.xy = r0.zw * r1.xx;
	r2.xy = texcoord.xy * 2 + -1;
	r1.z = 1;
	r2.z = dot(r0.xy, r0.xy) + 0;
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r0.xyz = (r0.xxx >= 0) ? r2.xyz : r1.xyz;
	r0.zw = r0.zz + float2(1, -1);
	r0.z = 1 / r0.z;
	r0.y = r0.z * r0.y;
	r0.x = r0.x + r0.x;
	r1.xy = r0.zz * r0.wx;
	r1.z = r0.y + r0.y;
	r2 = (-r0.y >= 0) ? float4(0, 1, 0, 1) : float4(1, 0, 1, 0);
	r0.x = max(abs(r1.y), abs(r1.z));
	r3.x = max(-r1.x, r0.x);
	r0.x = 1 / r3.x;
	r3 = r0.x * r1.yzxz;
	r0.xy = r0.xx * r1.yx;
	r1.x = -abs(r1.z) + abs(r1.y);
	r0.zw = r0.ww * -r0.zz + -abs(r1.yz);
	r4 = (-r1.y >= 0) ? float4(1, 0, 1, 0) : float4(0, 1, 0, 1);
	r2 = (r1.x >= 0) ? r4 : r2;
	r0.xy = (r1.xx >= 0) ? r3.zw : r0.xy;
	r0.w = (r0.w >= 0) ? -1 : -0;
	r0.z = (r0.z >= 0) ? r0.w : -0;
	r0.xy = (r0.zz >= 0) ? r0.xy : r3.xy;
	r3 = (r1.x >= 0) ? float4(0.25, 1, -0.25, 1) : float4(0.25, -1, 0.25, 1);
	r1 = (r1.x >= 0) ? float4(0.75, 1, 0.75, 1) : float4(1.25, 1, 1.25, 1);
	r1 = (r0.z >= 0) ? r1 : float4(0.25, 1, 0.25, 1);
	r3 = (r0.z >= 0) ? r3 : float4(0.25, 1, 0.25, 1);
	r2 = (r0.z >= 0) ? r2 : float4(1, 0, 0, 1);
	r1 = r0.xyxy * r3 + r1;
	r0.x = dot(r0.xy, r0.xy) + 1;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r1 = r1 * float4(0.6666667, 0.5, 0.6666667, 0.5);
	r3 = tex2D(HemiCubeSampler, r1.xy);
	r1 = tex2D(HemiCubeSampler, r1.zw);
	r0.y = dot(r1.xy, r2.zw) + 0;
	r0.z = dot(r3.xy, r2.xy) + 0;
	o.xy = r0.xx * r0.zy;
	o.zw = float2(0, 1);

	return o;
}
