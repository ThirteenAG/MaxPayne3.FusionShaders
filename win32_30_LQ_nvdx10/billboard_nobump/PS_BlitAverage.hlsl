sampler2D blitSampler : register(s2);

float4 main() : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0 = tex2D(blitSampler, 0.5);
	r1.x = dot(r0.xyz, 1);
	r2 = tex2D(blitSampler, float2(0.5, 1.5));
	r1.y = dot(r2.xyz, 1);
	r3 = tex2D(blitSampler, float2(0.5, 2.5));
	r1.z = dot(r3.xyz, 1);
	r4 = tex2D(blitSampler, float2(0.5, 3.5));
	r1.w = dot(r4.xyz, 1);
	r1 = r1 + -0.5;
	r1 = (r1 >= 0) ? 1 : 0;
	r2.xyz = r1.yyy * r2.xyz;
	r0.xyz = r0.xyz * r1.xxx + r2.xyz;
	r0.xyz = r3.xyz * r1.zzz + r0.xyz;
	r0.xyz = r4.xyz * r1.www + r0.xyz;
	r0.w = dot(r1, 1);
	r1 = tex2D(blitSampler, float2(0.5, 4.5));
	r2.x = dot(r1.xyz, 1);
	r3 = tex2D(blitSampler, float2(0.5, 5.5));
	r2.y = dot(r3.xyz, 1);
	r4 = tex2D(blitSampler, float2(0.5, 6.5));
	r2.z = dot(r4.xyz, 1);
	r5 = tex2D(blitSampler, float2(0.5, 7.5));
	r2.w = dot(r5.xyz, 1);
	r2 = r2 + -0.5;
	r2 = (r2 >= 0) ? 1 : 0;
	r0.xyz = r1.xyz * r2.xxx + r0.xyz;
	r0.xyz = r3.xyz * r2.yyy + r0.xyz;
	r0.xyz = r4.xyz * r2.zzz + r0.xyz;
	r0.xyz = r5.xyz * r2.www + r0.xyz;
	r1.x = dot(r2, 1);
	r0.w = r0.w + r1.x;
	r0.w = 1 / r0.w;
	o.xyz = r0.www * r0.xyz;
	o.w = 1;

	return o;
}
