sampler2D gDeferredLightSampler1 : register(s1);
float4 gooDeferredLightScreenSize : register(c118);

half4 main(float2 vpos : VPOS) : COLOR
{
	half4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1.yzw = float3(-1, -0.5, 0.5);
	r2 = gooDeferredLightScreenSize.zwzw * r1.yzwy + r0.xyxy;
	r3 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r2.xyz = r2.xyz + r3.xyz;
	r1 = gooDeferredLightScreenSize.zwzw * -r1.wyyz + r0.xyxy;
	r0 = tex2D(gDeferredLightSampler1, r0.xy);
	r3 = tex2D(gDeferredLightSampler1, r1.xy);
	r1 = tex2D(gDeferredLightSampler1, r1.zw);
	r2.xyz = r2.xyz + r3.xyz;
	r1.xyz = r1.xyz + r2.xyz;
	r0.xyz = r0.xyz * 0.5 + r1.xyz;
	o.xyz = r0.xyz * 0.22222222;
	o.w = 0;

	return o;
}
