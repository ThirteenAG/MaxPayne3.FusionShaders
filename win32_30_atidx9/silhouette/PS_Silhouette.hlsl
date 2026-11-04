sampler2D DepthBufferSampler : register(s0);
float4 gDepthFxParams : register(c18);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);

float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DepthBufferSampler, texcoord.xy);
	r0.x = r0.x * gDirectionalColour.z + -gDirectionalColour.w;
	r0.x = 1 / r0.x;
	r0.x = -r0.x + texcoord.z;
	r0.x = r0.x + gDirectionalLight.w;
	r0.x = gDirectionalLight.x * r0.x + -gDirectionalLight.y;
	r0.y = -gDirectionalLight.y + gDirectionalLight.z;
	r0.y = 1 / r0.y;
	r0.x = saturate(r0.y * r0.x);
	r0.y = r0.x * -2 + 3;
	r0.x = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	o = r0.x * gDepthFxParams;

	return o;
}
