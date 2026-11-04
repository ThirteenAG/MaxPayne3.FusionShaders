float4 LaserVisibilityMinMax : register(c98);

struct PS_IN
{
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.y = 0;
	r1.x = max(LaserVisibilityMinMax.x, r0.y);
	r0.x = min(LaserVisibilityMinMax.y, r1.x);
	r0.y = abs(i.texcoord3.y) * -abs(i.texcoord3.y) + 1;
	r1 = r0.y * i.texcoord4;
	r0 = r0.x * r1;
	r1.x = dot(r0.xyz, r0.www);
	r0.xyz = r1.xxx * 0.5 + r0.xyz;
	r1.x = saturate(5 * i.texcoord3.w);
	o = r0 * r1.x;

	return o;
}
