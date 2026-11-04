sampler2D gDeferredLightSampler0P : register(s3);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * globalScreenSize.zw;
	r0.xy = r0.xy + r0.xy;
	r0.zw = globalScreenSize.zw;
	r1 = r0.zwzw * float4(0, -4, 0, -2) + r0.xyxy;
	r2 = tex2D(gDeferredLightSampler0P, r1.xy);
	r1 = tex2D(gDeferredLightSampler0P, r1.zw);
	r1.xyz = r1.xyz + r2.xyz;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0 = r0.zwzw * float4(0, 2, 0, 4) + r0.xyxy;
	r1.xyz = r2.xyz * 0.5 + r1.xyz;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0 = tex2D(gDeferredLightSampler0P, r0.zw);
	r1.xyz = r1.xyz + r2.xyz;
	r0.xyz = r0.xyz + r1.xyz;
	o.xyz = r0.xyz * 0.22222222;
	o.w = 1;

	return o;
}
