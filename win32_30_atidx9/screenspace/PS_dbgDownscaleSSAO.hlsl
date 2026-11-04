sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gDeferredProjParams : register(c119);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.xy = 0.5 + vpos.xy;
	r0.xy = r0.xy * globalScreenSize.zw;
	r0.xy = r0.xy + r0.xy;
	r1.y = -0.5;
	r0.xy = globalScreenSize.zw * r1.yy + r0.xy;
	r0 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.y = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = r0.x + -0.99999994;
	r0.y = 1 / r0.y;
	r1.x = min(r0.y, 256);
	r0.y = frac(r1.x);
	r0.y = -r0.y + r1.x;
	r0.z = -r0.y + r1.x;
	r1.y = r0.y * 0.003921569;
	r0.y = r0.z * 255;
	r0.w = frac(r0.y);
	r0.y = -r0.w + r0.y;
	r0.z = r0.y * -0.003921569 + r0.z;
	r1.z = r0.y * 0.003921569;
	r0.y = r0.z * 65025;
	r0.z = frac(r0.y);
	r0.y = -r0.z + r0.y;
	r1.w = r0.y * 0.003921569;
	o.yzw = (r0.xxx >= 0) ? 1 : r1.yzw;
	o.x = 1;

	return o;
}
