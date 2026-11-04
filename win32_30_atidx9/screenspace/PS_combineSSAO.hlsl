float3 AmbientLightingParams : register(c105);
sampler2D gDeferredLightSampler0P : register(s3);
sampler2D gDeferredLightSampler1 : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float3 r0;
	float4 r1;
	r0.yz = float2(0.15, 1);
	r0.x = saturate(AmbientLightingParams.x * -r0.y + r0.z);
	r1 = tex2D(gDeferredLightSampler1, texcoord.xy);
	r0.y = r1.y + 0.2;
	o.w = r1.x;
	r0.x = saturate(r0.x + r0.y);
	r1 = tex2D(gDeferredLightSampler0P, texcoord.xy);
	r0.y = r1.x * AmbientLightingParams.y;
	o.yz = r1.yz;
	o.x = r0.x * r0.y;

	return o;
}
