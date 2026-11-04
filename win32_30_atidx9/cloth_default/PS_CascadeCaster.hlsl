sampler2D DiffuseSampler : register(s0);
float4 globalScalars : register(c35);

float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(DiffuseSampler, texcoord.yz);
	r0.x = r0.w * globalScalars.x;
	r1.x = 0.5019608;
	r0.y = r0.w * -globalScalars.x + r1.x;
	r1 = (r0.y >= 0) ? -1 : -0;
	clip(r1);
	o.xyz = texcoord.xxx;
	o.w = r0.x;

	return o;
}
