sampler2D WaterRippleSampler : register(s2);
float4 g_vRippleAttributes : register(c200);
float3 g_vRippleTexelSize : register(c198);

half4 main(float2 texcoord : TEXCOORD) : COLOR
{
	half4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xw = g_vRippleTexelSize.xy * g_vRippleTexelSize.zz;
	r0.yz = 0;
	r1 = -r0 + texcoord.xyxy;
	r0 = r0 + texcoord.xyxy;
	r2 = tex2D(WaterRippleSampler, r1.xy);
	r1 = tex2D(WaterRippleSampler, r1.zw);
	r3 = tex2D(WaterRippleSampler, r0.xy);
	r0 = tex2D(WaterRippleSampler, r0.zw);
	r0.y = r2.x + r3.x;
	r0.y = r1.x + r0.y;
	r0.x = r0.x + r0.y;
	r1 = tex2D(WaterRippleSampler, texcoord.xy);
	r0.x = r1.x * -4 + r0.x;
	r0.y = -r1.x + 0.5;
	r0.zw = r1.yx + -0.5;
	r0.y = r0.y * g_vRippleAttributes.w;
	r0.x = g_vRippleAttributes.y * r0.x + r0.y;
	r0.x = g_vRippleAttributes.x * r0.x + r0.z;
	r1.x = g_vRippleAttributes.x * r0.x + r0.w;
	r1.z = r0.x * g_vRippleAttributes.z;
	o = r1.xzxz + 0.5;

	return o;
}
