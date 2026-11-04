sampler2D WaterRippleSampler : register(s2);
float g_fRippleRainStrength : register(c199);
float3 g_vRippleTexelSize : register(c198);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xw = -g_vRippleTexelSize.xy;
	r0.yz = -0;
	r0 = r0 + texcoord.xyxy;
	r1 = tex2D(WaterRippleSampler, r0.xy);
	r0 = tex2D(WaterRippleSampler, r0.zw);
	r2 = tex2D(WaterRippleSampler, texcoord.xy);
	r0.y = -r1.x + r2.x;
	r0.x = -r0.x + r2.x;
	r1.xyz = float3(2, 1, 1);
	r0.z = g_fRippleRainStrength.x * r1.x + r1.y;
	r1.xy = r0.yx * -r0.zz;
	r0.xyz = r1.xyz + 1E-05;
	r0.z = dot(r0.xyz, r0.xyz);
	r1.z = rsqrt(r0.z);
	r1.xy = r0.xy * r1.zz;
	o.xyz = r1.xyz * float3(0.5, 0.5, 0.500005) + 0.5;
	o.w = 1;

	return o;
}
