sampler2D gDeferredLightSampler1 : register(s1);
float4 gooDeferredLightScreenSize : register(c118);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1.yzw = float3(-2, 0, -1);
	r2 = gooDeferredLightScreenSize.zwzw * r1.yzwz + r0.xyxy;
	r3 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r2.xyz = r2.xyz + r3.xyz;
	r3 = tex2D(gDeferredLightSampler1, r0.xy);
	r0 = gooDeferredLightScreenSize.zwzw * abs(r1.wzyz) + r0.xyxy;
	r1.xyz = r3.xyz * 0.5 + r2.xyz;
	r2 = tex2D(gDeferredLightSampler1, r0.xy);
	r0 = tex2D(gDeferredLightSampler1, r0.zw);
	r1.xyz = r1.xyz + r2.xyz;
	r0.xyz = r0.xyz + r1.xyz;
	o.xyz = r0.xyz * 0.22222222;
	o.w = 1;

	return o;
}
