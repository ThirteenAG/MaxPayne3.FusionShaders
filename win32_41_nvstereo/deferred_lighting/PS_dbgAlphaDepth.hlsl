Texture2D deferredLightTexture : register(t0);
Texture2D<float> gbufferTextureDepth : register(t11);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	int4 r0;
	float r1;
	r0.xy = (int2)sv_position.xy;
	r0.zw = int2(0, 0);
	r1 = deferredLightTexture.Load(r0.xyw).x;
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz).x);
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(asfloat(r0.x) * 1199.94995 + -1200);
	r0.y = asint(-(r1.x) + 1);
	r0.y = asint(asfloat(r0.y) * 1199.94995 + -1200);
	r0.xy = asint(float2(-60, -60) / asfloat(r0.xy));
	r0.x = asint(-(asfloat(r0.y)) + asfloat(r0.x));
	r0.y = asint(-(abs(asfloat(r0.x))) * 5 + 1);
	r0.x = (abs(asfloat(r0.x)) >= 0.00100000005) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.y = asint(max(asfloat(r0.y), 0));
	o.w = asfloat(r0.x) * asfloat(r0.y);
	o.xyz = float3(1, 0, 0);

	return o;
}
