float4 globalScalars : register(c35);

float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o.xyz = texcoord.xyz;
	o.w = globalScalars.x;

	return o;
}
