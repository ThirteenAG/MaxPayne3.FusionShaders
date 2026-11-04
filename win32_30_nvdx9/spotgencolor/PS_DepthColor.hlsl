float4 gShadowParam0123 : register(c54);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float3 r0;
	float r1;
	r0.x = 1 / texcoord.y;
	r0.x = texcoord.x * -r0.x + 1;
	r0.y = ddx(r0.x);
	r0.z = ddy(r0.x);
	r1 = max(abs(r0.y), abs(r0.z));
	r0.y = gShadowParam0123.y * r1.x + gShadowParam0123.x;
	o = r0.y + r0.x;

	return o;
}
