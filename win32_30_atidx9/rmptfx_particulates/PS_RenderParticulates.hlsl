sampler2D DepthMapTexSampler : register(s12);
sampler2D DiffuseTexSampler : register(s0);
float4 globalScreenSize : register(c41);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.y = 0.25;
	r0.xz = r0.yy * globalScreenSize.xy;
	r1.xy = i.texcoord2.xy * r0.xz + 0.03;
	r1.zw = frac(r1.xy);
	r1.xy = -r1.zw + r1.xy;
	r1.xy = r1.xy + 0.5;
	r2.x = 1 / r0.x;
	r2.y = 1 / r0.z;
	r0.xz = r1.xy * r2.xy;
	r1 = tex2D(DepthMapTexSampler, r0.xz);
	r0.x = dot(r1.yzw, float3(255, 1, 0.003921569));
	r0.z = abs(-r0.x);
	r0.x = -r0.x + -15;
	r0.z = r0.z + 1E-05;
	r1.x = pow(r0.z, 0.25001);
	r0.z = r1.x + -1.1892169;
	r0.x = (r0.x >= 0) ? 0.7788265 : r0.z;
	r0.zw = 0.5 * i.vpos.xy;
	r0.zw = frac(r0.zw);
	r0.z = r0.z + r0.z;
	r0.z = r0.w * 4 + r0.z;
	r1 = r0.z * r0.y + float4(0.03125, 0.09375, 0.15625, 0.21875);
	r0 = r1 * r0.x + 1.1892169;
	r0 = abs(r0) + 1E-05;
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r1.w = log2(r0.w);
	r0 = r1 * 4.00001;
	r1.x = exp2(r0.x);
	r1.y = exp2(r0.y);
	r1.z = exp2(r0.z);
	r1.w = exp2(r0.w);
	r0 = r1 + -i.texcoord.y;
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r2 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r3 = lerp(r1, r2, i.texcoord.w);
	r1.x = dot(r3.xyz, 1);
	r1.y = r3.w * i.texcoord.x;
	r1.z = r1.x * i.texcoord.z;
	r1.x = i.texcoord.z * r1.x + 1;
	r1.x = 1 / r1.x;
	r1.x = r1.x * r1.y;
	r1.y = 1 / r1.z;
	r0 = abs(r0) * -r1.y + 1;
	r2 = max(r0, 0);
	o = r1.x * r2;

	return o;
}
