sampler2D gDeferredLightSampler1 : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(gDeferredLightSampler1, texcoord.xy);
	r0.xy = r0.xx * float2(256, 128);
	r0.y = frac(r0.y);
	r0.x = r0.y * -2 + r0.x;
	r0.z = r0.x * 0.25;
	r0.z = frac(r0.z);
	r0.y = r0.z + r0.y;
	r0.x = r0.z * -4 + r0.x;
	r0.z = r0.x * 0.125;
	r0.z = frac(r0.z);
	r0.y = r0.z + r0.y;
	r0.x = r0.z * -8 + r0.x;
	r0.x = r0.x * 0.0625;
	r0.x = frac(r0.x);
	r0.x = r0.x + r0.y;
	o.xyz = r0.xxx * 0.5;
	o.w = 1;

	return o;
}
