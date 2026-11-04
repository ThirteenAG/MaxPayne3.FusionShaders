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
	r1 = r0.zwzw * float4(0, -7, 0, -3) + r0.xyxy;
	r2 = tex2D(gDeferredLightSampler0P, r1.zw);
	r1 = tex2D(gDeferredLightSampler0P, r1.xy);
	r1.y = r2.x * 0.25039;
	r1.x = r1.x * 0.09326 + r1.y;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0 = r0.zwzw * float4(0, 3, 0, 7) + r0.xyxy;
	r1.x = r2.x * 0.3127 + r1.x;
	o.yzw = r2.yzw;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r0 = tex2D(gDeferredLightSampler0P, r0.zw);
	r0.y = r2.x * 0.25039 + r1.x;
	o.x = r0.x * 0.09326 + r0.y;

	return o;
}
